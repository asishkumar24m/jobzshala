import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/localization/app_localizations.dart';

class MatchScoreBadge extends StatelessWidget {
  final double score;
  final bool isProminent;

  const MatchScoreBadge({
    super.key,
    required this.score,
    this.isProminent = false,
  });

  Color get _badgeColor {
    if (score >= 90.0) return AppColors.emerald600;
    if (score >= 80.0) return AppColors.teal600;
    return AppColors.amber600;
  }

  Color get _badgeBgColor {
    if (score >= 90.0) return AppColors.emerald50;
    if (score >= 80.0) return AppColors.teal50;
    return AppColors.amber50;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayPercent =
        '${score.toStringAsFixed(score.truncateToDouble() == score ? 0 : 1)}%';

    return Semantics(
      label: '$displayPercent ${l10n.matchPercentLabel}',
      readOnly: true,
      child: isProminent
          ? _buildProminent(displayPercent, l10n)
          : _buildCompact(displayPercent),
    );
  }

  Widget _buildProminent(String displayPercent, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: _badgeBgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _badgeColor.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.verified, size: 18, color: _badgeColor),
          const SizedBox(width: 6),
          Text(
            '$displayPercent ${l10n.matchPercentLabel}',
            style: AppTypography.numberMetric.copyWith(
              color: _badgeColor,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompact(String displayPercent) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: _badgeBgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _badgeColor.withValues(alpha: 0.2), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: _badgeColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            displayPercent,
            style: AppTypography.numberMetric.copyWith(
              color: _badgeColor,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
