import 'dart:math';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/app_exceptions.dart';
import 'mock_job_catalog.dart';
import 'models/job_model.dart';

class JobMatchesResponse {
  final List<Job> jobs;
  final int totalCount;
  final int page;
  final int totalPages;
  final bool hasMore;

  const JobMatchesResponse({
    required this.jobs,
    required this.totalCount,
    required this.page,
    required this.totalPages,
    required this.hasMore,
  });
}

class JobMockApi {
  final Random _random;
  final double failureRate;
  final bool disableDelay;
  final bool? forceSuccess;
  final bool? forceFailure;

  JobMockApi({
    Random? random,
    this.failureRate = AppConstants.mockApiDefaultFailureRate,
    this.disableDelay = false,
    this.forceSuccess,
    this.forceFailure,
  }) : _random = random ?? Random();

  Future<void> _simulateNetworkDelay() async {
    if (disableDelay) return;
    final delayMs =
        AppConstants.mockApiMinDelayMs +
        _random.nextInt(
          AppConstants.mockApiMaxDelayMs - AppConstants.mockApiMinDelayMs,
        );
    await Future<void>.delayed(Duration(milliseconds: delayMs));
  }

  void _evaluateSimulatedFailure(String endpoint) {
    if (forceSuccess == true) return;
    if (forceFailure == true || _random.nextDouble() < failureRate) {
      throw const ApiException(
        message:
            'The server encountered a temporary delay connecting to GCC employer databases. Please try again.',
        statusCode: 500,
        isRetryable: true,
      );
    }
  }

  /// Logical endpoint: GET /jobs/matches?country=UAE&page=1
  Future<JobMatchesResponse> getJobMatches({
    String? country,
    int page = 1,
    int limit = AppConstants.pageSize,
  }) async {
    await _simulateNetworkDelay();
    _evaluateSimulatedFailure('GET /jobs/matches');

    final allJobs = MockJobCatalog.catalog;

    // Filter by country if specified and not 'All'
    final filtered =
        (country == null ||
            country.isEmpty ||
            country == AppConstants.countryAll)
        ? allJobs
        : allJobs
              .where((j) => j.country.toLowerCase() == country.toLowerCase())
              .toList();

    // Ensure sorted by match score descending (highest first)
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

  /// Logical endpoint: GET /jobs/:id
  Future<Job> getJobById(String id) async {
    await _simulateNetworkDelay();
    _evaluateSimulatedFailure('GET /jobs/$id');

    final match = MockJobCatalog.catalog.where((j) => j.id == id).firstOrNull;
    if (match == null) {
      throw const ApiException(
        message: 'Job not found',
        statusCode: 404,
        isRetryable: false,
      );
    }

    return match;
  }

  /// Logical endpoint: POST /jobs/:id/apply
  Future<Map<String, dynamic>> applyJob(String id) async {
    await _simulateNetworkDelay();
    _evaluateSimulatedFailure('POST /jobs/$id/apply');

    final match = MockJobCatalog.catalog.where((j) => j.id == id).firstOrNull;
    if (match == null) {
      throw const ApiException(
        message: 'Cannot apply: Job does not exist',
        statusCode: 404,
        isRetryable: false,
      );
    }

    return {
      'status': 'APPLIED',
      'id': id,
      'applied_at': DateTime.now().toIso8601String(),
    };
  }
}
