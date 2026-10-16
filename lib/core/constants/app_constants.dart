class AppConstants {
  AppConstants._();

  static const String appName = 'Jobzshala';
  static const String appTagline = 'Verified Gulf Jobs for Skilled Workers';

  // Country filters
  static const String countryAll = 'All';
  static const String countryUae = 'UAE';
  static const String countrySaudi = 'Saudi Arabia';
  static const String countryQatar = 'Qatar';

  static const List<String> availableCountries = [
    countryAll,
    countryUae,
    countrySaudi,
    countryQatar,
  ];

  // Pagination
  static const int pageSize = 20;

  // Mock API configuration
  static const int mockApiMinDelayMs = 800;
  static const int mockApiMaxDelayMs = 1500;
  static const double mockApiDefaultFailureRate =
      0.20; // ~20% simulated HTTP 500 server errors per assignment requirement
  static const int mockCatalogTotalJobs = 210;

  // Local storage keys
  static const String storageKeyAppliedJobIds = 'jobzshala_applied_job_ids_v1';
  static const String storageKeyCachedJobs = 'jobzshala_cached_jobs_v1';
  static const String storageKeySelectedLocale = 'jobzshala_selected_locale_v1';
}
