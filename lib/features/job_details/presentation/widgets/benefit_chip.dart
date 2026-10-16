import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';

class BenefitChip extends StatelessWidget {
  final String title;
  final bool isIncluded;
  final IconData icon;

  const BenefitChip({
    super.key,
    required this.title,
    required this.isIncluded,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final statusText = isIncluded
        ? l10n.benefitIncluded
        : l10n.benefitNotIncluded;

    return Semantics(
      label: '$title: $statusText',
      readOnly: true,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isIncluded ? AppColors.teal50 : AppColors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isIncluded
                ? AppColors.teal600.withValues(alpha: 0.25)
                : AppColors.border,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isIncluded
                    ? AppColors.teal600
                    : AppColors.textSecondary.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 18,
                color: isIncluded ? Colors.white : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    statusText,
                    style: AppTypography.bodySmall.copyWith(
                      color: isIncluded
                          ? AppColors.teal700
                          : AppColors.textSecondary,
                      fontWeight: isIncluded
                          ? FontWeight.w600
                          : FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              isIncluded ? Icons.check_circle_rounded : Icons.cancel_outlined,
              size: 20,
              color: isIncluded ? AppColors.teal600 : AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}
