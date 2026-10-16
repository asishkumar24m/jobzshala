import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/country_utils.dart';
import '../../../../shared/widgets/pressable_scale.dart';
import '../../../job_matches/data/models/job_model.dart';

class ApplicationConfirmationSheet extends StatelessWidget {
  final Job job;
  final VoidCallback onDismiss;

  const ApplicationConfirmationSheet({
    super.key,
    required this.job,
    required this.onDismiss,
  });

  static Future<void> show(BuildContext context, {required Job job}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ApplicationConfirmationSheet(
        job: job,
        onDismiss: () {
          // Pop modal and pop details screen back to home feed
          Navigator.of(ctx).popUntil((route) => route.isFirst);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final cleanNumber = job.id
        .replaceAll(RegExp(r'[^0-9]'), '')
        .padLeft(4, '0');
    final refCode = 'JZ-$cleanNumber';
    final flag = CountryUtils.getFlag(job.country);

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Color(0x28000000),
            blurRadius: 28,
            offset: Offset(0, -6),
          ),
        ],
      ),
      padding: EdgeInsets.fromLTRB(
        20,
        14,
        20,
        20 +
            MediaQuery.of(context).viewInsets.bottom +
            MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Drag handle
          Container(
            width: 44,
            height: 4.5,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 18),

          // Success Header with double-ring badge
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.teal50,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.teal500.withValues(alpha: 0.25),
                width: 3,
              ),
            ),
            child: Center(
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: AppColors.teal600,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Heading
          Text(
            l10n.confirmationHeading,
            style: AppTypography.headingSmall.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),

          // Subtitle
          Text(
            l10n.confirmationSubtitle,
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.textSecondary,
              fontSize: 13,
              height: 1.45,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 18),

          // Application Reference ID Card with One-Tap Copy
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surfaceMuted,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.applicationIdLabel.toUpperCase(),
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textMuted,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      refCode,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.navy900,
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                Semantics(
                  label: '${l10n.copyLabel} $refCode',
                  button: true,
                  child: PressableScale(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: refCode));
                      HapticFeedback.lightImpact();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Row(
                            children: [
                              const Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '${l10n.refCodeCopied} $refCode',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: AppColors.navy900,
                          behavior: SnackBarBehavior.floating,
                          duration: const Duration(seconds: 2),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border, width: 1),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.copy_rounded,
                            size: 13,
                            color: AppColors.navy800,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.copyLabel,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.navy800,
                              fontWeight: FontWeight.w600,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Job Summary Pill
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.navy900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(flag, style: const TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: AppTypography.labelMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${job.employerDisplay} • ${job.city}, ${job.country}',
                        style: AppTypography.bodySmall.copyWith(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Next Steps Timeline (Reassurance for candidates)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.whatHappensNext,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.navy900,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 10),
                _TimelineStep(
                  step: 1,
                  isDone: true,
                  title: l10n.step1Title,
                  subtitle: l10n.step1Subtitle,
                ),
                const SizedBox(height: 8),
                _TimelineStep(
                  step: 2,
                  isDone: false,
                  title: l10n.step2Title,
                  subtitle: l10n.step2Subtitle,
                ),
                const SizedBox(height: 8),
                _TimelineStep(
                  step: 3,
                  isDone: false,
                  title: l10n.step3Title,
                  subtitle: l10n.step3Subtitle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),

          // Primary Done Action: "Explore More Jobs" -> Returns to Home!
          Semantics(
            label: l10n.backToMatches,
            button: true,
            child: PressableScale(
              onTap: onDismiss,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.teal600,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.teal600.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.arrow_back_rounded,
                      size: 18,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      l10n.backToMatches,
                      style: AppTypography.labelMedium.copyWith(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final int step;
  final bool isDone;
  final String title;
  final String subtitle;

  const _TimelineStep({
    required this.step,
    required this.isDone,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: isDone ? AppColors.teal600 : const Color(0xFFE2E8F0),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 12, color: Colors.white)
                : Text(
                    '$step',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTypography.labelSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: isDone ? AppColors.navy900 : const Color(0xFF475569),
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.bodySmall.copyWith(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
