import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../core/utils/country_utils.dart';
import '../../../job_application/presentation/providers/job_application_provider.dart';
import '../../../job_application/presentation/widgets/application_confirmation_dialog.dart';
import '../../../job_matches/data/models/job_model.dart';
import '../../../job_matches/presentation/widgets/match_score_badge.dart';
import '../widgets/benefit_chip.dart';
import '../widgets/sticky_apply_bar.dart';

class JobDetailsScreen extends StatelessWidget {
  final Job job;

  const JobDetailsScreen({super.key, required this.job});

  void _handleApply(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final applicationProvider = context.read<JobApplicationProvider>();

    applicationProvider.applyForJob(
      job.id,
      onSuccess: () {
        // Show rich confirmation sheet
        ApplicationConfirmationSheet.show(context, job: job);
      },
      onFailure: (errorMessage) {
        // Show production-level rollback feedback and retry action
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: AppColors.navy900,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: AppColors.error, width: 1.2),
            ),
            duration: const Duration(seconds: 5),
            content: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 2),
                  child: Icon(
                    Icons.error_outline_rounded,
                    color: AppColors.error,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n.applicationRollbackTitle,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.applicationRollbackMessage,
                        style: const TextStyle(
                          fontSize: 11.5,
                          color: Color(0xFFCBD5E1),
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            action: SnackBarAction(
              label: l10n.retry.toUpperCase(),
              textColor: AppColors.teal500,
              onPressed: () => _handleApply(context),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final connectivity = context.watch<ConnectivityService>();
    final applicationProvider = context.watch<JobApplicationProvider>();

    final isOffline = !connectivity.isConnected;
    final isApplied = applicationProvider.isJobApplied(job.id);
    final isSubmitting = applicationProvider.isJobInFlight(job.id);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          l10n.jobDetailsTitle,
          style: AppTypography.headingSmall.copyWith(fontSize: 18),
        ),
        leading: Semantics(
          label: 'Back',
          button: true,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: MatchScoreBadge(score: job.matchScore),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Scrollable Content
          SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header Card: Title, Employer, City, Country, Salary
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                    boxShadow: AppColors.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        job.title,
                        style: AppTypography.headingMedium.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              job.employerDisplay,
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.verified_rounded,
                            size: 14,
                            color: AppColors.teal600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.verifiedEmployer,
                            style: AppTypography.labelSmall.copyWith(
                              fontSize: 11,
                              color: AppColors.teal700,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Location & Date Pill
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.surfaceMuted,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  CountryUtils.getFlag(job.country),
                                  style: const TextStyle(fontSize: 13),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${job.city}, ${job.country}',
                                  style: AppTypography.labelSmall.copyWith(
                                    color: AppColors.navy900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '${l10n.postedDate}: ${job.postedAt.day}/${job.postedAt.month}/${job.postedAt.year}',
                            style: AppTypography.bodySmall.copyWith(
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),
                      const Divider(height: 1, color: AppColors.borderSubtle),
                      const SizedBox(height: 14),

                      // Salary Highlight
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.salaryPerMonth,
                            style: AppTypography.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            job.formattedSalaryRange,
                            style: AppTypography.headingSmall.copyWith(
                              color: AppColors.teal700,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Match Reason Card (Prominent Callout)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.teal50,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.teal600.withValues(alpha: 0.25),
                      width: 1.2,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome,
                            color: AppColors.teal700,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.whyYouMatch,
                            style: AppTypography.labelMedium.copyWith(
                              color: AppColors.teal700,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        job.matchReason,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.navy900,
                          height: 1.45,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Skills Required
                Text(
                  l10n.skillsLabel,
                  style: AppTypography.headingSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: job.skills.map((skill) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.border, width: 1.2),
                      ),
                      child: Text(
                        skill,
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.navy900,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 24),

                // Benefits Section (Accommodation, Food, Visa)
                Text(
                  l10n.benefits,
                  style: AppTypography.headingSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 12),
                Column(
                  children: [
                    BenefitChip(
                      title: l10n.benefitAccommodation,
                      isIncluded: job.benefits.accommodation,
                      icon: Icons.hotel_rounded,
                    ),
                    const SizedBox(height: 8),
                    BenefitChip(
                      title: l10n.benefitFood,
                      isIncluded: job.benefits.food,
                      icon: Icons.restaurant_rounded,
                    ),
                    const SizedBox(height: 8),
                    BenefitChip(
                      title: l10n.benefitVisa,
                      isIncluded: job.benefits.visa,
                      icon: Icons.assignment_ind_rounded,
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // Full Job Description
                Text(
                  l10n.description,
                  style: AppTypography.headingSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    job.description,
                    style: AppTypography.bodyMedium.copyWith(
                      height: 1.55,
                      color: AppColors.navy800,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Requirements Section
                Text(
                  l10n.requirements,
                  style: AppTypography.headingSmall.copyWith(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: job.requirements.map((req) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 2),
                              child: Icon(
                                Icons.check_circle_outline_rounded,
                                size: 16,
                                color: AppColors.teal600,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                req,
                                style: AppTypography.bodyMedium.copyWith(
                                  height: 1.45,
                                  color: AppColors.navy800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Sticky Persistent Apply Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: StickyApplyBar(
              isApplied: isApplied,
              isSubmitting: isSubmitting,
              isOffline: isOffline,
              onApply: () => _handleApply(context),
            ),
          ),
        ],
      ),
    );
  }
}
