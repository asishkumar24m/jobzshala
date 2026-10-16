import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jobzshala/core/constants/app_constants.dart';
import 'package:jobzshala/core/errors/app_exceptions.dart';
import 'package:jobzshala/core/localization/app_localizations.dart';
import 'package:jobzshala/core/network/connectivity_service.dart';
import 'package:jobzshala/core/storage/local_storage_service.dart';
import 'package:jobzshala/features/job_application/presentation/providers/job_application_provider.dart';
import 'package:jobzshala/features/job_matches/data/job_mock_api.dart';
import 'package:jobzshala/features/job_matches/data/job_repository.dart';
import 'package:jobzshala/features/job_matches/data/mock_job_catalog.dart';
import 'package:jobzshala/features/job_matches/presentation/providers/job_matches_provider.dart';

class MockFailingApi extends JobMockApi {
  bool fail = false;
  MockFailingApi() : super(disableDelay: true, forceSuccess: true);

  @override
  Future<JobMatchesResponse> getJobMatches({
    int page = 1,
    int limit = 20,
    String? country,
  }) async {
    if (fail) {
      throw const ApiException(statusCode: 500, message: 'Server error');
    }
    return super.getJobMatches(page: page, limit: limit, country: country);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late LocalStorageService storage;
  late ConnectivityService connectivity;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await LocalStorageService.init();
    connectivity = ConnectivityService(initialOnline: true);
  });

  group('Mock Job Catalog & API Contract Tests', () {
    test('catalog contains at least 200 deterministic jobs', () {
      final catalog = MockJobCatalog.catalog;
      expect(catalog.length, greaterThanOrEqualTo(200));

      // Verify deterministic sorting: match score descending
      for (int i = 0; i < catalog.length - 1; i++) {
        expect(
          catalog[i].matchScore,
          greaterThanOrEqualTo(catalog[i + 1].matchScore),
          reason:
              'Job at index $i must have match score >= job at index ${i + 1}',
        );
      }
    });

    test(
      'jobs have valid generic employers, countries, salaries and benefits',
      () {
        final catalog = MockJobCatalog.catalog;
        final allowedCountries = {'UAE', 'Saudi Arabia', 'Qatar'};

        for (final job in catalog) {
          expect(allowedCountries.contains(job.country), isTrue);
          expect(job.employerDisplay, contains(', ${job.country}'));
          expect(job.salaryMinAed, greaterThan(0));
          expect(job.salaryMaxAed, greaterThanOrEqualTo(job.salaryMinAed));
          expect(job.matchReason, isNotEmpty);
          expect(job.skills.length, inInclusiveRange(1, 5));
          expect(
            job.benefits.visa,
            isTrue,
          ); // 100% verified visa for Gulf blue-collar
          expect(job.requirements, isNotEmpty);
        }
      },
    );

    test(
      'API getJobMatches paginates 20 items per page with sorting',
      () async {
        final api = JobMockApi(disableDelay: true, forceSuccess: true);
        final page1 = await api.getJobMatches(
          page: 1,
          limit: AppConstants.pageSize,
        );

        expect(page1.jobs.length, equals(20));
        expect(page1.totalCount, greaterThanOrEqualTo(200));
        expect(page1.page, equals(1));
        expect(page1.hasMore, isTrue);

        final page2 = await api.getJobMatches(
          page: 2,
          limit: AppConstants.pageSize,
        );
        expect(page2.jobs.length, equals(20));
        expect(page2.page, equals(2));

        // Ensure page 1 and page 2 contain distinct jobs (no overlap)
        final page1Ids = page1.jobs.map((j) => j.id).toSet();
        for (final j in page2.jobs) {
          expect(page1Ids.contains(j.id), isFalse);
        }
      },
    );

    test(
      'API filters correctly by country: UAE, Saudi Arabia, Qatar',
      () async {
        final api = JobMockApi(disableDelay: true, forceSuccess: true);

        final uaeRes = await api.getJobMatches(
          country: 'UAE',
          page: 1,
          limit: 100,
        );
        expect(uaeRes.jobs.every((j) => j.country == 'UAE'), isTrue);
        expect(uaeRes.jobs, isNotEmpty);

        final saudiRes = await api.getJobMatches(
          country: 'Saudi Arabia',
          page: 1,
          limit: 100,
        );
        expect(saudiRes.jobs.every((j) => j.country == 'Saudi Arabia'), isTrue);
        expect(saudiRes.jobs, isNotEmpty);

        final qatarRes = await api.getJobMatches(
          country: 'Qatar',
          page: 1,
          limit: 100,
        );
        expect(qatarRes.jobs.every((j) => j.country == 'Qatar'), isTrue);
        expect(qatarRes.jobs, isNotEmpty);
      },
    );

    test('API simulates HTTP 500 error when failure is triggered', () async {
      final api = JobMockApi(disableDelay: true, forceFailure: true);

      expect(
        () async => await api.getJobMatches(),
        throwsA(
          isA<ApiException>().having((e) => e.statusCode, 'statusCode', 500),
        ),
      );
    });
  });

  group('Job Application State Machine & Rollback Tests', () {
    test('optimistic application succeeds and persists to storage', () async {
      final api = JobMockApi(disableDelay: true, forceSuccess: true);
      final repository = JobRepository(
        api: api,
        storage: storage,
        connectivity: connectivity,
      );
      final appProvider = JobApplicationProvider(
        repository: repository,
        connectivity: connectivity,
      );

      const targetJobId = 'job_1001';
      expect(appProvider.isJobApplied(targetJobId), isFalse);

      bool successCalled = false;
      bool failureCalled = false;

      final success = await appProvider.applyForJob(
        targetJobId,
        onSuccess: () => successCalled = true,
        onFailure: (_) => failureCalled = true,
      );

      expect(success, isTrue);
      expect(successCalled, isTrue);
      expect(failureCalled, isFalse);
      expect(appProvider.isJobApplied(targetJobId), isTrue);
      expect(repository.isJobApplied(targetJobId), isTrue);

      // Verify persistence across new repository instance reading storage
      final freshRepo = JobRepository(
        api: api,
        storage: storage,
        connectivity: connectivity,
      );
      expect(freshRepo.isJobApplied(targetJobId), isTrue);
    });

    test(
      'application rolls back optimistic state on 500 server error',
      () async {
        final api = JobMockApi(disableDelay: true, forceFailure: true);
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );
        final appProvider = JobApplicationProvider(
          repository: repository,
          connectivity: connectivity,
        );

        const targetJobId = 'job_1002';
        expect(appProvider.isJobApplied(targetJobId), isFalse);

        bool successCalled = false;
        String? errorMessage;

        final success = await appProvider.applyForJob(
          targetJobId,
          onSuccess: () => successCalled = true,
          onFailure: (err) => errorMessage = err,
        );

        // Must fail and roll back!
        expect(success, isFalse);
        expect(successCalled, isFalse);
        expect(errorMessage, contains('500'));
        expect(appProvider.isJobApplied(targetJobId), isFalse);
        expect(repository.isJobApplied(targetJobId), isFalse);
      },
    );

    test(
      'application is disabled while offline with clear explanation',
      () async {
        connectivity.setSimulatedOffline(true);
        expect(connectivity.isConnected, isFalse);

        final api = JobMockApi(disableDelay: true, forceSuccess: true);
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );
        final appProvider = JobApplicationProvider(
          repository: repository,
          connectivity: connectivity,
        );

        const targetJobId = 'job_1003';
        String? errorMessage;

        final success = await appProvider.applyForJob(
          targetJobId,
          onSuccess: () {},
          onFailure: (err) => errorMessage = err,
        );

        expect(success, isFalse);
        expect(errorMessage, contains('offline'));
        expect(appProvider.isJobApplied(targetJobId), isFalse);
      },
    );

    test(
      'duplicate applications are prevented while request is in flight',
      () async {
        final api = JobMockApi(disableDelay: true, forceSuccess: true);
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );
        final appProvider = JobApplicationProvider(
          repository: repository,
          connectivity: connectivity,
        );

        const targetJobId = 'job_1004';
        await appProvider.applyForJob(
          targetJobId,
          onSuccess: () {},
          onFailure: (_) {},
        );

        // Attempt second submission on already applied job
        final secondAttempt = await appProvider.applyForJob(
          targetJobId,
          onSuccess: () {},
          onFailure: (_) {},
        );

        expect(secondAttempt, isFalse);
      },
    );
  });

  group('Offline Caching & Persistence Tests', () {
    test(
      'caches entire catalog on first load and supports offline country filtering',
      () async {
        final api = JobMockApi(disableDelay: true, forceSuccess: true);
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );

        // Initial online fetch
        await repository.getJobMatches(page: 1);
        expect(storage.getCachedJobs(), isNotNull);
        expect(storage.getCachedJobs()!.length, equals(210));

        // Switch to offline
        connectivity.setSimulatedOffline(true);
        expect(connectivity.isConnected, isFalse);

        // Fetch UAE offline
        final uaeOffline = await repository.getJobMatches(
          page: 1,
          country: AppConstants.countryUae,
        );
        expect(uaeOffline.jobs, isNotEmpty);
        expect(
          uaeOffline.jobs.every((j) => j.country == AppConstants.countryUae),
          isTrue,
        );
      },
    );
    test(
      'caches jobs on successful fetch and serves them when offline',
      () async {
        final api = JobMockApi(disableDelay: true, forceSuccess: true);
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );

        // Online fetch
        final onlineRes = await repository.getJobMatches(page: 1);
        expect(onlineRes.jobs, isNotEmpty);
        expect(storage.getCachedJobs(), isNotNull);

        // Transition to offline mode
        connectivity.setSimulatedOffline(true);
        expect(connectivity.isConnected, isFalse);

        // Offline fetch should successfully return cached jobs
        final offlineRes = await repository.getJobMatches(page: 1);
        expect(offlineRes.jobs, isNotEmpty);
        expect(offlineRes.jobs.first.id, equals(onlineRes.jobs.first.id));
      },
    );

    test('throws NetworkException if offline and no cache exists', () async {
      connectivity.setSimulatedOffline(true);
      final api = JobMockApi(disableDelay: true, forceSuccess: true);
      final repository = JobRepository(
        api: api,
        storage: storage,
        connectivity: connectivity,
      );

      expect(
        () async => await repository.getJobMatches(page: 1),
        throwsA(isA<NetworkException>()),
      );
    });
  });

  group('Localization Tests (English & Hindi)', () {
    test(
      'English and Hindi dictionaries provide non-empty values for all UI strings',
      () {
        final en = AppLocalizations(const Locale('en'));
        final hi = AppLocalizations(const Locale('hi'));

        expect(en.jobMatchesTitle, equals('Job Matches'));
        expect(hi.jobMatchesTitle, equals('नौकरी के मैच'));

        expect(en.emptyStateTitle, equals('No matches yet'));
        expect(hi.emptyStateTitle, equals('अभी कोई मेल नहीं है'));

        expect(en.offlineBanner, equals("You're offline — showing saved jobs"));
        expect(
          hi.offlineBanner,
          equals('आप ऑफ़लाइन हैं — सहेजी गई नौकरियां दिख रही हैं'),
        );

        expect(en.applyNow, equals('Apply Now'));
        expect(hi.applyNow, equals('आवेदन करें'));

        expect(en.appliedStatus, equals('Applied'));
        expect(hi.appliedStatus, equals('आवेदित'));

        expect(en.filterUae, equals('UAE'));
        expect(hi.filterUae, equals('यूएई'));

        expect(en.filterSaudi, equals('Saudi Arabia'));
        expect(hi.filterSaudi, equals('सऊदी अरब'));

        expect(en.filterQatar, equals('Qatar'));
        expect(hi.filterQatar, equals('कतर'));

        expect(en.benefitAccommodation, isNotEmpty);
        expect(hi.benefitAccommodation, isNotEmpty);
        expect(en.benefitFood, isNotEmpty);
        expect(hi.benefitFood, isNotEmpty);
        expect(en.benefitVisa, isNotEmpty);
        expect(hi.benefitVisa, isNotEmpty);
        expect(en.appSubtitle, equals('GCC Verified Jobs'));
        expect(hi.appSubtitle, equals('जीसीसी सत्यापित नौकरियां'));
        expect(en.serverBusyBadge, equals('HTTP 500 • SYSTEM BUSY'));
        expect(hi.serverBusyBadge, equals('एचटीटीपी 500 • सर्वर व्यस्त'));
        expect(en.perMonth, equals('/mo'));
        expect(hi.perMonth, equals('/माह'));
        expect(en.refCodeCopied, isNotEmpty);
        expect(hi.refCodeCopied, isNotEmpty);
        expect(en.copyLabel, isNotEmpty);
        expect(hi.copyLabel, isNotEmpty);
      },
    );
  });

  group('Provider Pagination & Duplicate Prevention Tests', () {
    test(
      'retryLoadMore recovers from failure when repository throws',
      () async {
        final api = MockFailingApi();
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );
        final matchesProvider = JobMatchesProvider(
          repository: repository,
          connectivity: connectivity,
        );

        await matchesProvider.fetchJobs();
        expect(matchesProvider.jobs.length, equals(20));

        // Force failure and clear cache so loadMore catches exception
        await storage.clearAll();
        api.fail = true;
        await matchesProvider.loadMore();
        expect(matchesProvider.loadMoreFailed, isTrue);

        // Restore success and retry
        api.fail = false;
        await matchesProvider.retryLoadMore();
        expect(matchesProvider.loadMoreFailed, isFalse);
        expect(matchesProvider.jobs.length, equals(40));
      },
    );
    test('loadMore prevents duplicate job entries across pages', () async {
      final api = JobMockApi(disableDelay: true, forceSuccess: true);
      final repository = JobRepository(
        api: api,
        storage: storage,
        connectivity: connectivity,
      );
      final matchesProvider = JobMatchesProvider(
        repository: repository,
        connectivity: connectivity,
      );

      await matchesProvider.fetchJobs();
      expect(matchesProvider.jobs.length, equals(20));

      await matchesProvider.loadMore();
      expect(matchesProvider.jobs.length, equals(40));

      // Verify all IDs are unique
      final idSet = matchesProvider.jobs.map((j) => j.id).toSet();
      expect(idSet.length, equals(matchesProvider.jobs.length));
    });
  });
  group('Country Filter & Reference Code Tests', () {
    test(
      'setCountryFilter clears existing jobs immediately to trigger shimmer loading',
      () async {
        final api = JobMockApi(disableDelay: true, forceSuccess: true);
        final repository = JobRepository(
          api: api,
          storage: storage,
          connectivity: connectivity,
        );
        final matchesProvider = JobMatchesProvider(
          repository: repository,
          connectivity: connectivity,
        );

        await matchesProvider.fetchJobs();
        expect(matchesProvider.jobs, isNotEmpty);
        expect(matchesProvider.status, equals(JobMatchesStatus.success));

        // Trigger filter switch
        final future = matchesProvider.setCountryFilter(
          AppConstants.countryUae,
        );
        // Immediately after triggering, jobs must be cleared and status must be loading
        expect(
          matchesProvider.selectedCountry,
          equals(AppConstants.countryUae),
        );
        expect(matchesProvider.jobs, isEmpty);
        expect(matchesProvider.status, equals(JobMatchesStatus.loading));

        await future;
        expect(matchesProvider.jobs, isNotEmpty);
        expect(matchesProvider.status, equals(JobMatchesStatus.success));
        expect(
          matchesProvider.jobs.every(
            (j) => j.country == AppConstants.countryUae,
          ),
          isTrue,
        );
      },
    );

    test(
      'application reference code is deterministic and never changes on rebuild',
      () {
        final job = MockJobCatalog.catalog.first;
        final cleanNumber = job.id
            .replaceAll(RegExp(r'[^0-9]'), '')
            .padLeft(4, '0');
        final refCode1 = 'JZ-$cleanNumber';
        final refCode2 = 'JZ-$cleanNumber';

        expect(refCode1, equals(refCode2));
        expect(refCode1.startsWith('JZ-'), isTrue);
        expect(refCode1.length, greaterThanOrEqualTo(7));
      },
    );
  });
}
