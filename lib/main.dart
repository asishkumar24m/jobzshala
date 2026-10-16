import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'core/localization/locale_provider.dart';
import 'core/network/connectivity_service.dart';
import 'core/storage/local_storage_service.dart';
import 'features/job_application/presentation/providers/job_application_provider.dart';
import 'features/job_matches/data/job_mock_api.dart';
import 'features/job_matches/data/job_repository.dart';
import 'features/job_matches/presentation/providers/job_matches_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Fix portrait orientation for mobile
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  // Initialize Local Storage
  final storageService = await LocalStorageService.init();

  // Initialize Network Connectivity Service
  final connectivityService = ConnectivityService();

  // Initialize Mock API Layer
  final mockApi = JobMockApi();

  // Initialize Job Repository
  final jobRepository = JobRepository(
    api: mockApi,
    storage: storageService,
    connectivity: connectivityService,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<LocalStorageService>.value(value: storageService),
        ChangeNotifierProvider<ConnectivityService>.value(
          value: connectivityService,
        ),
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(storageService),
        ),
        ChangeNotifierProvider<JobMatchesProvider>(
          create: (_) => JobMatchesProvider(
            repository: jobRepository,
            connectivity: connectivityService,
          ),
        ),
        ChangeNotifierProvider<JobApplicationProvider>(
          create: (_) => JobApplicationProvider(
            repository: jobRepository,
            connectivity: connectivityService,
          ),
        ),
      ],
      child: const JobzshalaApp(),
    ),
  );
}
