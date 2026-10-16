import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';

class OfflineBanner extends StatelessWidget {
  final bool hasCachedJobs;

  const OfflineBanner({super.key, required this.hasCachedJobs});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = hasCachedJobs
        ? l10n.offlineBanner
        : l10n.offlineNoSavedJobsTitle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.offlineBannerBg,
        border: Border(
          bottom: BorderSide(color: AppColors.offlineBannerBorder, width: 1),
        ),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off_rounded,
            size: 18,
            color: AppColors.offlineBannerText,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.offlineBannerText,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
