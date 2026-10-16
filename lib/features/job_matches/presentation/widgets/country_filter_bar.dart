import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/country_utils.dart';
import '../../../../shared/widgets/pressable_scale.dart';

class CountryFilterBar extends StatelessWidget {
  final String selectedCountry;
  final ValueChanged<String> onCountrySelected;

  const CountryFilterBar({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  String _getLocalizedLabel(BuildContext context, String country) {
    final l10n = AppLocalizations.of(context);
    switch (country) {
      case AppConstants.countryAll:
        return l10n.filterAll;
      case AppConstants.countryUae:
        return l10n.filterUae;
      case AppConstants.countrySaudi:
        return l10n.filterSaudi;
      case AppConstants.countryQatar:
        return l10n.filterQatar;
      default:
        return country;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      color: AppColors.background,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        itemCount: AppConstants.availableCountries.length,
        separatorBuilder: (_, index) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final country = AppConstants.availableCountries[index];
          final isSelected =
              country.toLowerCase() == selectedCountry.toLowerCase();
          final label = _getLocalizedLabel(context, country);
          final flag = CountryUtils.getFlag(country);

          return Semantics(
            label: '$label, ${isSelected ? "selected" : "not selected"}',
            button: true,
            selected: isSelected,
            child: PressableScale(
              onTap: () => onCountrySelected(country),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOutCubic,
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6.5,
                ),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.navy900 : AppColors.surface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.navy900
                        : const Color(0xFFE2E8F0),
                    width: isSelected ? 1.5 : 1.0,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.navy900.withValues(alpha: 0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : const [
                          BoxShadow(
                            color: Color(0x05000000),
                            blurRadius: 4,
                            offset: Offset(0, 1),
                          ),
                        ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 13.5)),
                    const SizedBox(width: 6),
                    Text(
                      label,
                      style: AppTypography.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.navy900,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
