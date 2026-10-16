import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:jobzshala/app/app.dart';
import 'package:jobzshala/core/localization/locale_provider.dart';
import 'package:jobzshala/core/network/connectivity_service.dart';
import 'package:jobzshala/core/storage/local_storage_service.dart';
import 'package:jobzshala/features/job_application/presentation/providers/job_application_provider.dart';
import 'package:jobzshala/features/job_matches/data/job_mock_api.dart';
import 'package:jobzshala/features/job_matches/data/job_repository.dart';
import 'package:jobzshala/features/job_matches/presentation/providers/job_matches_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'Jobzshala app smoke test: loads header, filters, and language toggle',
    (tester) async {
      SharedPreferences.setMockInitialValues({});
      final storage = await LocalStorageService.init();
      final connectivity = ConnectivityService(initialOnline: true);
      final api = JobMockApi(disableDelay: true, forceSuccess: true);
      final repository = JobRepository(
        api: api,
        storage: storage,
        connectivity: connectivity,
      );

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            Provider<LocalStorageService>.value(value: storage),
            ChangeNotifierProvider<ConnectivityService>.value(
              value: connectivity,
            ),
            ChangeNotifierProvider<LocaleProvider>(
              create: (_) => LocaleProvider(storage),
            ),
            ChangeNotifierProvider<JobMatchesProvider>(
              create: (_) => JobMatchesProvider(
                repository: repository,
                connectivity: connectivity,
              ),
            ),
            ChangeNotifierProvider<JobApplicationProvider>(
              create: (_) => JobApplicationProvider(
                repository: repository,
                connectivity: connectivity,
              ),
            ),
          ],
          child: const JobzshalaApp(),
        ),
      );

      // Initial pump
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Verify app brand and title
      expect(find.text('Jobzshala'), findsWidgets);
      expect(find.text('GCC Verified Jobs'), findsOneWidget);
      expect(find.text('Job Matches'), findsOneWidget);

      // Verify language toggle
      expect(find.text('English'), findsOneWidget);

      // Verify country filters
      expect(find.text('All'), findsOneWidget);
      expect(find.text('UAE'), findsOneWidget);
      expect(find.text('Saudi Arabia'), findsOneWidget);
      expect(find.text('Qatar'), findsOneWidget);
    },
  );
}
