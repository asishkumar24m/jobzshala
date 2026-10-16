import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/app_constants.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService(prefs);
  }

  // Applied Job IDs
  Set<String> getAppliedJobIds() {
    final list =
        _prefs.getStringList(AppConstants.storageKeyAppliedJobIds) ?? [];
    return list.toSet();
  }

  Future<bool> saveAppliedJobId(String jobId) async {
    final current = getAppliedJobIds();
    current.add(jobId);
    return _prefs.setStringList(
      AppConstants.storageKeyAppliedJobIds,
      current.toList(),
    );
  }

  Future<bool> removeAppliedJobId(String jobId) async {
    final current = getAppliedJobIds();
    current.remove(jobId);
    return _prefs.setStringList(
      AppConstants.storageKeyAppliedJobIds,
      current.toList(),
    );
  }

  // Cached Jobs
  List<Map<String, dynamic>>? getCachedJobs() {
    final rawJson = _prefs.getString(AppConstants.storageKeyCachedJobs);
    if (rawJson == null || rawJson.isEmpty) {
      return null;
    }
    try {
      final decoded = jsonDecode(rawJson) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveCachedJobs(List<Map<String, dynamic>> jobs) async {
    try {
      final encoded = jsonEncode(jobs);
      return await _prefs.setString(AppConstants.storageKeyCachedJobs, encoded);
    } catch (_) {
      return false;
    }
  }

  // Locale Preference
  String? getSavedLocaleCode() {
    return _prefs.getString(AppConstants.storageKeySelectedLocale);
  }

  Future<bool> saveLocaleCode(String code) {
    return _prefs.setString(AppConstants.storageKeySelectedLocale, code);
  }

  // Clear for testing
  Future<void> clearAll() async {
    await _prefs.clear();
  }
}
