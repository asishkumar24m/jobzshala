import 'package:flutter/material.dart';
import '../storage/local_storage_service.dart';

class LocaleProvider extends ChangeNotifier {
  final LocalStorageService _storageService;
  Locale _currentLocale = const Locale('en');

  LocaleProvider(this._storageService) {
    _loadSavedLocale();
  }

  Locale get currentLocale => _currentLocale;
  bool get isHindi => _currentLocale.languageCode == 'hi';

  void _loadSavedLocale() {
    final savedCode = _storageService.getSavedLocaleCode();
    if (savedCode != null && (savedCode == 'en' || savedCode == 'hi')) {
      _currentLocale = Locale(savedCode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (_currentLocale == locale) return;
    _currentLocale = locale;
    await _storageService.saveLocaleCode(locale.languageCode);
    notifyListeners();
  }

  Future<void> toggleLocale() async {
    if (_currentLocale.languageCode == 'en') {
      await setLocale(const Locale('hi'));
    } else {
      await setLocale(const Locale('en'));
    }
  }
}
