class CountryUtils {
  CountryUtils._();

  /// Returns the national flag emoji for supported GCC countries
  static String getFlag(String country) {
    switch (country.trim().toLowerCase()) {
      case 'uae':
        return '🇦🇪';
      case 'saudi arabia':
        return '🇸🇦';
      case 'qatar':
        return '🇶🇦';
      default:
        return '🌐';
    }
  }
}
