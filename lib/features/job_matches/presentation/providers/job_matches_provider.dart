import 'package:flutter/foundation.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../data/job_repository.dart';
import '../../data/models/job_model.dart';

enum JobMatchesStatus { initial, loading, loadingMore, success, empty, error }

class JobMatchesProvider extends ChangeNotifier {
  final JobRepository repository;
  final ConnectivityService connectivity;

  JobMatchesStatus _status = JobMatchesStatus.initial;
  List<Job> _jobs = [];
  String _selectedCountry = AppConstants.countryAll;
  int _currentPage = 1;
  bool _hasMore = true;
  String? _errorMessage;
  bool _isOfflineBannerActive = false;
  bool _isShowingFallbackCache = false;
  bool _isFetching = false;
  bool _loadMoreFailed = false;

  JobMatchesProvider({required this.repository, required this.connectivity}) {
    connectivity.addListener(_handleConnectivityChanged);
  }

  JobMatchesStatus get status => _status;
  List<Job> get jobs => _jobs;
  String get selectedCountry => _selectedCountry;
  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  String? get errorMessage => _errorMessage;
  bool get isOfflineBannerActive => _isOfflineBannerActive;
  bool get isShowingFallbackCache => _isShowingFallbackCache;
  bool get isFetching => _isFetching;
  bool get loadMoreFailed => _loadMoreFailed;
  bool get isLoading => _status == JobMatchesStatus.loading;
  bool get isLoadingMore => _status == JobMatchesStatus.loadingMore;
  bool get isConnected => connectivity.isConnected;

  void _handleConnectivityChanged() {
    final nowOffline = !connectivity.isConnected;
    if (nowOffline != _isOfflineBannerActive) {
      _isOfflineBannerActive = nowOffline;
      // Refresh current matches from repository (reads full cache when offline)
      fetchJobs(refresh: true);
    }
  }

  @override
  void dispose() {
    connectivity.removeListener(_handleConnectivityChanged);
    super.dispose();
  }

  Future<void> fetchJobs({bool refresh = false}) async {
    if (_isFetching && !refresh) return;
    _isFetching = true;

    if (refresh) {
      _currentPage = 1;
      _hasMore = true;
      _jobs = [];
    }

    _loadMoreFailed = false;
    _isOfflineBannerActive = !connectivity.isConnected;
    _status = JobMatchesStatus.loading;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await repository.getJobMatches(
        country: _selectedCountry,
        page: 1,
        limit: AppConstants.pageSize,
      );

      _jobs = response.jobs;
      _hasMore = response.hasMore;
      _currentPage = 1;
      _isShowingFallbackCache = false;
      _status = _jobs.isEmpty
          ? JobMatchesStatus.empty
          : JobMatchesStatus.success;
    } on NetworkException catch (e) {
      if (_jobs.isNotEmpty) {
        _status = JobMatchesStatus.success;
      } else {
        _status = JobMatchesStatus.error;
        _errorMessage = e.message;
      }
    } on ApiException catch (e) {
      if (_jobs.isNotEmpty) {
        _status = JobMatchesStatus.success;
        _errorMessage = e.message;
      } else {
        // Resilient production recovery: check if device has saved cache
        final cached = repository.getCachedJobsList(country: _selectedCountry);
        if (cached.isNotEmpty) {
          _jobs = cached;
          _status = JobMatchesStatus.success;
          _isShowingFallbackCache = true;
          _errorMessage = e.message;
        } else {
          // Zero cache on fresh device: show clean, reassuring production error card
          _status = JobMatchesStatus.error;
          _errorMessage = e.message;
        }
      }
    } catch (e) {
      _status = JobMatchesStatus.error;
      _errorMessage = 'An unexpected error occurred: $e';
    } finally {
      _isFetching = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore ||
        _status == JobMatchesStatus.loadingMore ||
        _status == JobMatchesStatus.loading ||
        _isFetching) {
      return;
    }

    _status = JobMatchesStatus.loadingMore;
    _loadMoreFailed = false;
    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final response = await repository.getJobMatches(
        country: _selectedCountry,
        page: nextPage,
        limit: AppConstants.pageSize,
      );

      final existingIds = _jobs.map((j) => j.id).toSet();
      final newUniqueJobs = response.jobs
          .where((j) => !existingIds.contains(j.id))
          .toList();

      _jobs.addAll(newUniqueJobs);
      _currentPage = nextPage;
      _hasMore = response.hasMore;
      _loadMoreFailed = false;
      _status = JobMatchesStatus.success;
    } catch (_) {
      _loadMoreFailed = true;
      _status = JobMatchesStatus.success;
    } finally {
      notifyListeners();
    }
  }

  Future<void> retryLoadMore() async {
    _loadMoreFailed = false;
    await loadMore();
  }

  Future<void> setCountryFilter(String country) async {
    if (_selectedCountry == country) return;
    _selectedCountry = country;
    _currentPage = 1;
    _hasMore = true;
    _jobs = [];
    _isShowingFallbackCache = false;
    _status = JobMatchesStatus.loading;
    _errorMessage = null;
    notifyListeners();
    await fetchJobs(refresh: true);
  }

  bool isJobApplied(String jobId) {
    return repository.isJobApplied(jobId);
  }

  void notifyAppliedUpdated() {
    notifyListeners();
  }
}
