import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../shared/widgets/pressable_scale.dart';

class StickyApplyBar extends StatelessWidget {
  final bool isApplied;
  final bool isSubmitting;
  final bool isOffline;
  final VoidCallback onApply;

  const StickyApplyBar({
    super.key,
    required this.isApplied,
    required this.isSubmitting,
    required this.isOffline,
    required this.onApply,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    Widget buttonContent;
    Color buttonBg;
    Color textColor;
    VoidCallback? effectiveOnTap;

    if (isOffline) {
      buttonBg = AppColors.surfaceMuted;
      textColor = AppColors.textMuted;
      effectiveOnTap = null;
      buttonContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.cloud_off_rounded,
            size: 18,
            color: AppColors.textMuted,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.applyNow,
            style: AppTypography.labelMedium.copyWith(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ],
      );
    } else if (isSubmitting) {
      buttonBg = AppColors.teal700;
      textColor = Colors.white;
      effectiveOnTap = null;
      buttonContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            l10n.applying,
            style: AppTypography.labelMedium.copyWith(
              color: textColor,
              fontSize: 15,
            ),
          ),
        ],
      );
    } else if (isApplied) {
      buttonBg = AppColors.successSurface;
      textColor = AppColors.success;
      effectiveOnTap = null;
      buttonContent = Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 20,
            color: AppColors.success,
          ),
          const SizedBox(width: 8),
          Text(
            l10n.appliedStatus,
            style: AppTypography.labelMedium.copyWith(
              color: textColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      );
    } else {
      buttonBg = AppColors.teal600;
      textColor = Colors.white;
      effectiveOnTap = onApply;
      buttonContent = Text(
        l10n.applyNow,
        style: AppTypography.labelMedium.copyWith(
          color: textColor,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      );
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A0F172A),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        bottomPadding > 0 ? bottomPadding + 6 : 14,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isOffline) ...[
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(
                    Icons.info_outline_rounded,
                    size: 14,
                    color: AppColors.offlineBannerText,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      l10n.offlineApplyDisabled,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.offlineBannerText,
                        fontSize: 11.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
          Semantics(
            label: isOffline
                ? l10n.offlineApplyDisabled
                : (isApplied ? l10n.alreadyApplied : l10n.applyNow),
            button: true,
            enabled: effectiveOnTap != null,
            child: PressableScale(
              onTap: effectiveOnTap,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: buttonBg,
                  borderRadius: BorderRadius.circular(14),
                  border: isApplied
                      ? Border.all(color: AppColors.successBorder, width: 1.5)
                      : (isOffline
                            ? Border.all(color: AppColors.border, width: 1)
                            : null),
                  boxShadow: (effectiveOnTap != null)
                      ? [
                          BoxShadow(
                            color: AppColors.teal600.withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                alignment: Alignment.center,
                child: buttonContent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
