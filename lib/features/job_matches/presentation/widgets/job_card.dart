import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/utils/country_utils.dart';
import '../../../../shared/widgets/pressable_scale.dart';
import '../../data/models/job_model.dart';
import 'match_score_badge.dart';

class JobCard extends StatelessWidget {
  final Job job;
  final bool isApplied;
  final VoidCallback onTap;

  const JobCard({
    super.key,
    required this.job,
    required this.isApplied,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayedSkills = job.skills.take(3).toList();
    final flag = CountryUtils.getFlag(job.country);

    return Semantics(
      label:
          '${job.title}, ${job.employerDisplay}, ${job.city}, ${job.country}. '
          '${job.formattedSalaryRange} ${l10n.salaryPerMonth}. '
          '${job.matchScore.toInt()}% ${l10n.matchPercentLabel}. '
          '${isApplied ? l10n.appliedStatus : l10n.applyNow}.',
      button: true,
      child: PressableScale(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6.5),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isApplied
                  ? AppColors.teal600.withValues(alpha: 0.35)
                  : const Color(0xFFE2E8F0),
              width: isApplied ? 1.5 : 1.0,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0A0F172A),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
              BoxShadow(
                color: Color(0x050F172A),
                blurRadius: 18,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Title, Employer & Match Score Badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          job.title,
                          style: AppTypography.headingSmall.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                job.employerDisplay,
                                style: AppTypography.bodySmall.copyWith(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 13,
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
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  MatchScoreBadge(score: job.matchScore),
                ],
              ),

              const SizedBox(height: 12),

              // Location & Salary Row
              Row(
                children: [
                  Text(flag, style: const TextStyle(fontSize: 13)),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '${job.city}, ${job.country}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                        fontSize: 12.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Salary display pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3.5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.teal50,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: AppColors.teal600.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          job.formattedSalaryRange,
                          style: AppTypography.salaryBadge.copyWith(
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(width: 2),
                        Text(
                          l10n.perMonth,
                          style: AppTypography.bodySmall.copyWith(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.teal700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 12),
              const Divider(color: Color(0xFFF1F5F9), height: 1),
              const SizedBox(height: 10),

              // Bottom Row: Skill Chips & Applied Status
              Row(
                children: [
                  // Skill Chips (up to 3)
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: displayedSkills.map((skill) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 0.8,
                            ),
                          ),
                          child: Text(
                            skill,
                            style: AppTypography.labelSmall.copyWith(
                              color: const Color(0xFF334155),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  // Applied Badge
                  if (isApplied)
                    Container(
                      margin: const EdgeInsets.only(left: 8),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4.5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.successSurface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.successBorder,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.check_circle_rounded,
                            size: 13,
                            color: AppColors.success,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            l10n.appliedStatus.toUpperCase(),
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.success,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
