import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import '../../../core/network/connectivity_service.dart';
import '../../../core/storage/local_storage_service.dart';
import 'job_mock_api.dart';
import 'mock_job_catalog.dart';
import 'models/job_model.dart';

class JobRepository {
  final JobMockApi api;
  final LocalStorageService storage;
  final ConnectivityService connectivity;

  JobRepository({
    required this.api,
    required this.storage,
    required this.connectivity,
  });

  /// Fetch jobs with country filtering and pagination.
  /// Automatically uses cached data when offline.
  Future<JobMatchesResponse> getJobMatches({
    String? country,
    int page = 1,
    int limit = AppConstants.pageSize,
  }) async {
    final isOnline = connectivity.isConnected;

    if (!isOnline) {
      // Offline mode: load from device cache
      final cachedJsonList = storage.getCachedJobs();
      if (cachedJsonList == null || cachedJsonList.isEmpty) {
        throw const NetworkException(
          message: 'Offline: No cached jobs available on device.',
        );
      }

      final allCachedJobs = cachedJsonList.map((e) => Job.fromJson(e)).toList();

      final filtered =
          (country == null ||
              country.isEmpty ||
              country == AppConstants.countryAll)
          ? allCachedJobs
          : allCachedJobs
                .where((j) => j.country.toLowerCase() == country.toLowerCase())
                .toList();

      final sorted = List<Job>.from(filtered)
        ..sort((a, b) => b.matchScore.compareTo(a.matchScore));

      final totalCount = sorted.length;
      final totalPages = (totalCount / limit).ceil();
      final startIndex = (page - 1) * limit;

      if (startIndex >= totalCount) {
        return JobMatchesResponse(
          jobs: const [],
          totalCount: totalCount,
          page: page,
          totalPages: totalPages,
          hasMore: false,
        );
      }

      final endIndex = (startIndex + limit > totalCount)
          ? totalCount
          : startIndex + limit;
      final pagedJobs = sorted.sublist(startIndex, endIndex);

      return JobMatchesResponse(
        jobs: pagedJobs,
        totalCount: totalCount,
        page: page,
        totalPages: totalPages,
        hasMore: endIndex < totalCount,
      );
    }

    // Online mode: call Mock API
    final response = await api.getJobMatches(
      country: country,
      page: page,
      limit: limit,
    );

    // Warm full 210-job cache on device so all countries and pages are available offline
    if (response.jobs.isNotEmpty) {
      final fullCatalogCache = MockJobCatalog.catalog
          .map((j) => j.toJson())
          .toList();
      await storage.saveCachedJobs(fullCatalogCache);
    }

    return response;
  }

  /// Retrieve full details for a single job
  Future<Job> getJobDetails(String id) async {
    final isOnline = connectivity.isConnected;
    if (!isOnline) {
      final cached = storage.getCachedJobs();
      if (cached != null) {
        for (final item in cached) {
          if (item['id'] == id) {
            return Job.fromJson(item);
          }
        }
      }
      throw const NetworkException(
        message: 'Job details cannot be fetched while offline.',
      );
    }

    return await api.getJobById(id);
  }

  /// Submit job application
  Future<Map<String, dynamic>> applyForJob(String id) async {
    final isOnline = connectivity.isConnected;
    if (!isOnline) {
      throw const NetworkException(
        message: 'Cannot apply while offline. Please connect to the internet.',
      );
    }

    final result = await api.applyJob(id);
    await storage.saveAppliedJobId(id);
    return result;
  }

  /// Roll back optimistic applied status on network/server failure
  Future<void> rollbackApplication(String id) async {
    await storage.removeAppliedJobId(id);
  }

  /// Retrieve cached jobs directly for resilient fallback
  List<Job> getCachedJobsList({String? country}) {
    final cachedJsonList = storage.getCachedJobs();
    if (cachedJsonList == null || cachedJsonList.isEmpty) return [];

    final allCachedJobs = cachedJsonList.map((e) => Job.fromJson(e)).toList();

    final filtered =
        (country == null ||
            country.isEmpty ||
            country == AppConstants.countryAll)
        ? allCachedJobs
        : allCachedJobs
              .where((j) => j.country.toLowerCase() == country.toLowerCase())
              .toList();

    return List<Job>.from(filtered)
      ..sort((a, b) => b.matchScore.compareTo(a.matchScore));
  }

  /// Get set of applied job IDs persisted on device
  Set<String> getAppliedJobIds() {
    return storage.getAppliedJobIds();
  }

  bool isJobApplied(String id) {
    return storage.getAppliedJobIds().contains(id);
  }
}
