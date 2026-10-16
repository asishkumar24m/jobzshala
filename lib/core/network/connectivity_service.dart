import 'package:flutter/foundation.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOnline = true;
  bool _isSimulatedOffline = false;

  ConnectivityService({bool initialOnline = true}) : _isOnline = initialOnline;

  /// Returns true if currently connected to network and not simulated offline.
  bool get isConnected => _isOnline && !_isSimulatedOffline;

  /// Returns true if manual simulation of offline mode is activated.
  bool get isSimulatedOffline => _isSimulatedOffline;

  void setOnline(bool online) {
    if (_isOnline == online) return;
    _isOnline = online;
    notifyListeners();
  }

  void toggleSimulatedOffline() {
    _isSimulatedOffline = !_isSimulatedOffline;
    notifyListeners();
  }

  void setSimulatedOffline(bool simulateOffline) {
    if (_isSimulatedOffline == simulateOffline) return;
    _isSimulatedOffline = simulateOffline;
    notifyListeners();
  }
}
