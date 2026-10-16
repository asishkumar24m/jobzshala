import 'package:flutter/foundation.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../job_matches/data/job_repository.dart';

enum ApplicationState { unapplied, submitting, applied, failed }

class JobApplicationProvider extends ChangeNotifier {
  final JobRepository repository;
  final ConnectivityService connectivity;

  final Set<String> _inFlightJobIds = {};
  final Set<String> _optimisticAppliedJobIds = {};
  final Map<String, String> _lastErrors = {};

  JobApplicationProvider({
    required this.repository,
    required this.connectivity,
  });

  bool isJobInFlight(String jobId) => _inFlightJobIds.contains(jobId);

  bool isJobApplied(String jobId) {
    if (_optimisticAppliedJobIds.contains(jobId)) return true;
    return repository.isJobApplied(jobId);
  }

  String? getLastError(String jobId) => _lastErrors[jobId];

  ApplicationState getJobState(String jobId) {
    if (_inFlightJobIds.contains(jobId)) {
      return ApplicationState.submitting;
    }
    if (isJobApplied(jobId)) {
      return ApplicationState.applied;
    }
    if (_lastErrors.containsKey(jobId)) {
      return ApplicationState.failed;
    }
    return ApplicationState.unapplied;
  }

  /// Executes optimistic application state machine with rollback on failure
  Future<bool> applyForJob(
    String jobId, {
    required VoidCallback onSuccess,
    required void Function(String error) onFailure,
  }) async {
    // Prevent duplicate submission while in flight
    if (_inFlightJobIds.contains(jobId)) {
      return false;
    }

    // Prevent submitting if already applied
    if (isJobApplied(jobId)) {
      return false;
    }

    // Check connectivity: offline applications must be disabled
    if (!connectivity.isConnected) {
      const errorMsg =
          'Applications are disabled while offline. Reconnect to submit.';
      _lastErrors[jobId] = errorMsg;
      notifyListeners();
      onFailure(errorMsg);
      return false;
    }

    // 1. Enter optimistic submitting + applied state
    _inFlightJobIds.add(jobId);
    _optimisticAppliedJobIds.add(jobId);
    _lastErrors.remove(jobId);
    notifyListeners();

    try {
      // 2. Execute network call through mock API
      await repository.applyForJob(jobId);

      // 3. Success: remove from in-flight, confirmed in persistent storage
      _inFlightJobIds.remove(jobId);
      _optimisticAppliedJobIds.add(jobId);
      notifyListeners();

      onSuccess();
      return true;
    } catch (error) {
      // 4. Failure: Roll back optimistic update immediately
      _inFlightJobIds.remove(jobId);
      _optimisticAppliedJobIds.remove(jobId);
      await repository.rollbackApplication(jobId);

      final String message;
      if (error is ApiException) {
        message = 'Server Error (${error.statusCode}): ${error.message}';
      } else if (error is NetworkException) {
        message = error.message;
      } else {
        message = 'Application submission failed: $error';
      }

      _lastErrors[jobId] = message;
      notifyListeners();

      onFailure(message);
      return false;
    }
  }

  void clearError(String jobId) {
    _lastErrors.remove(jobId);
    notifyListeners();
  }
}
