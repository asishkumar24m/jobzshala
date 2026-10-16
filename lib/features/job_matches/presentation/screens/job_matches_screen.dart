import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_typography.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/localization/locale_provider.dart';
import '../../../../core/network/connectivity_service.dart';
import '../../../../shared/widgets/pressable_scale.dart';
import '../../../job_application/presentation/providers/job_application_provider.dart';
import '../../../job_details/presentation/screens/job_details_screen.dart';
import '../../data/models/job_model.dart';
import '../providers/job_matches_provider.dart';
import '../widgets/country_filter_bar.dart';
import '../widgets/job_card.dart';
import '../widgets/job_card_skeleton.dart';
import '../widgets/offline_banner.dart';

class JobMatchesScreen extends StatefulWidget {
  const JobMatchesScreen({super.key});

  @override
  State<JobMatchesScreen> createState() => _JobMatchesScreenState();
}

class _JobMatchesScreenState extends State<JobMatchesScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    // Initial job fetch
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<JobMatchesProvider>().fetchJobs();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;

    // Trigger next page when 250px from bottom (infinite scrolling)
    if (maxScroll - currentScroll <= 250) {
      context.read<JobMatchesProvider>().loadMore();
    }
  }

  Future<void> _handleRefresh() async {
    await context.read<JobMatchesProvider>().fetchJobs(refresh: true);
  }

  void _navigateToDetails(Job job) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (context) => JobDetailsScreen(job: job)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final localeProvider = context.watch<LocaleProvider>();
    final connectivity = context.watch<ConnectivityService>();
    final matchesProvider = context.watch<JobMatchesProvider>();
    final applicationProvider = context.watch<JobApplicationProvider>();

    final isOffline = !connectivity.isConnected;
    final hasCached = matchesProvider.jobs.isNotEmpty;
    final isShowingFallback = matchesProvider.isShowingFallbackCache;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(66),
        child: AppBar(
          backgroundColor: AppColors.surface,
          elevation: 0,
          titleSpacing: 12,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.navy900,
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Center(
                  child: Icon(
                    Icons.work_outline_rounded,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.appTitle,
                      style: AppTypography.headingSmall.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      l10n.appSubtitle,
                      style: AppTypography.labelSmall.copyWith(
                        fontSize: 10,
                        color: AppColors.teal700,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            // Network Simulation Toggle (for demo and assignment verification)
            Semantics(
              label:
                  '${l10n.networkSimulation}: ${isOffline ? l10n.simulationOffline : l10n.simulationOnline}',
              button: true,
              child: Tooltip(
                message: l10n.toggleNetworkTooltip,
                child: PressableScale(
                  onTap: () {
                    connectivity.toggleSimulatedOffline();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: isOffline
                          ? AppColors.offlineBannerBg
                          : AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isOffline
                            ? AppColors.offlineBannerBorder
                            : AppColors.border,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: BoxDecoration(
                            color: isOffline
                                ? AppColors.offlineBannerText
                                : AppColors.success,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          isOffline
                              ? l10n.simulationOffline
                              : l10n.simulationOnline,
                          style: AppTypography.labelSmall.copyWith(
                            color: isOffline
                                ? AppColors.offlineBannerText
                                : AppColors.navy800,
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Language Toggle Switcher (EN / HI)
            Semantics(
              label:
                  'Switch language. Current: ${localeProvider.isHindi ? "Hindi" : "English"}',
              button: true,
              child: PressableScale(
                onTap: () {
                  localeProvider.toggleLocale();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal50,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppColors.teal600.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.translate_rounded,
                        size: 13,
                        color: AppColors.teal700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        localeProvider.isHindi ? 'हिंदी' : 'English',
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.teal700,
                          fontSize: 11,
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
      ),
      body: Column(
        children: [
          // Offline Status Banner
          if (isOffline) OfflineBanner(hasCachedJobs: hasCached),

          // Resilient 500 Server Fallback Banner (Stale-While-Revalidate)
          if (!isOffline && isShowingFallback)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: AppColors.amber50,
              child: Row(
                children: [
                  const Icon(
                    Icons.warning_amber_rounded,
                    size: 16,
                    color: AppColors.amber600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.showingCachedFallbackBanner,
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.amber600,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  PressableScale(
                    onTap: () => matchesProvider.fetchJobs(refresh: true),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.amber600.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Text(
                        l10n.retry.toUpperCase(),
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.navy900,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // Header Title & Filter Metadata Bar
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            color: AppColors.background,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    l10n.jobMatchesTitle,
                    style: AppTypography.headingMedium.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8),
                if (matchesProvider.jobs.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceMuted,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 0.8),
                    ),
                    child: Text(
                      '${matchesProvider.jobs.length}+ ${l10n.jobsCountLabel}',
                      style: AppTypography.labelSmall.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Country Filter Horizontal Tabs
          CountryFilterBar(
            selectedCountry: matchesProvider.selectedCountry,
            onCountrySelected: (c) {
              matchesProvider.setCountryFilter(c);
            },
          ),

          const Divider(height: 1, color: AppColors.border),

          // Body Content with State Machine
          Expanded(
            child: _buildBody(context, matchesProvider, applicationProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    JobMatchesProvider matchesProvider,
    JobApplicationProvider applicationProvider,
  ) {
    final l10n = AppLocalizations.of(context);

    // Initial / Loading State (Skeleton Loaders)
    if (matchesProvider.status == JobMatchesStatus.loading &&
        matchesProvider.jobs.isEmpty) {
      return ListView.builder(
        key: const ValueKey('skeleton_shimmer_view'),
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: 4,
        itemBuilder: (context, index) => const JobCardSkeleton(),
      );
    }

    // Clean Production Error State (When zero cache exists)
    if (matchesProvider.status == JobMatchesStatus.error &&
        matchesProvider.jobs.isEmpty) {
      return Center(
        key: const ValueKey('error_view'),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ambient icon badge
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: AppColors.amber50,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.amber500.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Icon(
                    Icons.cloud_off_rounded,
                    size: 38,
                    color: AppColors.amber600,
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Production HTTP status chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceMuted,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  l10n.serverBusyBadge,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Reassuring title
              Text(
                l10n.serverInterruptionTitle,
                style: AppTypography.headingSmall.copyWith(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // User-centered explanation
              Text(
                l10n.serverInterruptionMessage,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),

              // High-affordance Retry Button
              PressableScale(
                onTap: () => matchesProvider.fetchJobs(refresh: true),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 13,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.teal600,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.teal600.withValues(alpha: 0.28),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.refresh_rounded,
                        size: 18,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        l10n.retry,
                        style: AppTypography.labelMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              if (matchesProvider.selectedCountry !=
                  AppConstants.countryAll) ...[
                const SizedBox(height: 14),
                PressableScale(
                  onTap: () =>
                      matchesProvider.setCountryFilter(AppConstants.countryAll),
                  child: Text(
                    l10n.showAllJobs,
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.navy800,
                      fontWeight: FontWeight.w600,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Empty State ("No matches yet")
    if (matchesProvider.status == JobMatchesStatus.empty ||
        matchesProvider.jobs.isEmpty) {
      return Center(
        key: const ValueKey('empty_view'),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceMuted,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.search_off_rounded,
                  size: 32,
                  color: AppColors.textMuted,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.emptyStateTitle,
                style: AppTypography.headingSmall.copyWith(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.emptyStateMessage,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              if (matchesProvider.selectedCountry !=
                  AppConstants.countryAll) ...[
                const SizedBox(height: 20),
                PressableScale(
                  onTap: () =>
                      matchesProvider.setCountryFilter(AppConstants.countryAll),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border, width: 1.2),
                    ),
                    child: Text(
                      l10n.clearFilter,
                      style: AppTypography.labelMedium.copyWith(
                        color: AppColors.navy900,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    // Success State: List with 200+ jobs, infinite scroll, pull-to-refresh
    final jobs = matchesProvider.jobs;

    return RefreshIndicator(
      key: ValueKey('jobs_list_${matchesProvider.selectedCountry}'),
      color: AppColors.teal600,
      backgroundColor: AppColors.surface,
      onRefresh: _handleRefresh,
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: jobs.length + (matchesProvider.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == jobs.length) {
            // Check if loadMore experienced an error
            if (matchesProvider.loadMoreFailed) {
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 24.0,
                ),
                child: Center(
                  child: PressableScale(
                    onTap: () => matchesProvider.retryLoadMore(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceMuted,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.refresh_rounded,
                            size: 16,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            l10n.loadMoreError,
                            style: AppTypography.labelSmall.copyWith(
                              color: AppColors.textSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }

            // Normal Pagination loading footer
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 24.0),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.teal600,
                    ),
                  ),
                ),
              ),
            );
          }

          final job = jobs[index];
          final isApplied = applicationProvider.isJobApplied(job.id);

          return JobCard(
            job: job,
            isApplied: isApplied,
            onTap: () => _navigateToDetails(job),
          );
        },
      ),
    );
  }
}
