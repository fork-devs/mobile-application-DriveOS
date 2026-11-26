import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_loading_helpers.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_tactile_card.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/controllers/dashboard_view_model.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/widgets/dtc_alert_banner.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';

/// Workshop administrator analytics and operational overview dashboard.
class DashboardPage extends StatefulWidget {
  /// Optional injected [DashboardViewModel] for testing.
  final DashboardViewModel? viewModel;

  /// Callback to switch to the Orders tab.
  final VoidCallback? onNavigateToOrders;

  /// Callback to switch to the Appointments tab.
  final VoidCallback? onNavigateToAppointments;

  /// Callback to switch to the Inventory tab.
  final VoidCallback? onNavigateToInventory;

  /// Callback to switch to the Telemetry tab.
  final VoidCallback? onNavigateToIot;

  /// Creates a [DashboardPage].
  const DashboardPage({
    super.key,
    this.viewModel,
    this.onNavigateToOrders,
    this.onNavigateToAppointments,
    this.onNavigateToInventory,
    this.onNavigateToIot,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late final DashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<DashboardViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.init();
    });
  }

  Future<void> _signOut() async {
    if (getIt.isRegistered<Logout>()) {
      await getIt<Logout>()();
    } else if (getIt.isRegistered<SessionStorage>()) {
      await getIt<SessionStorage>().clearSession();
    }
    if (mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final vm = _viewModel;
        final summary = vm.branchSummary;
        final totalRevenue =
            summary?.totalRevenue ?? vm.tenantSummary?.totalRevenue ?? 0.0;
        final completedOrders = summary?.completedWorkOrdersCount ??
            vm.tenantSummary?.completedWorkOrders ??
            0;
        final appointmentsCount = summary?.totalAppointmentsCount ?? 0;
        final lowStockCount = summary?.lowStockAlertsCount ?? 0;
        final dtcAlertsCount =
            summary?.dtcAlertsCount ?? vm.tenantSummary?.totalAlerts ?? 0;

        return Scaffold(
          backgroundColor: DriveOSColors.warmNeutral,
          body: DriveOSCollapsibleHeaderBody(
            header: DriveOSPageHeader(
              title: loc.translate('dashboard_tab'),
              subtitle: vm.activeBranchName,
              actions: [
                IconButton(
                  tooltip: loc.translate('switch_branch'),
                  icon: const Icon(
                    Icons.storefront_outlined,
                    color: Colors.white,
                  ),
                  onPressed: () => context.go('/branches'),
                ),
                IconButton(
                  tooltip: loc.translate('sign_out'),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: _signOut,
                ),
              ],
            ),
            body: DriveOSContentTransition(
              child: vm.isLoading && summary == null
                  ? const DriveOSSkeletonDetail(
                      key: ValueKey('dashboard_skeleton'),
                    )
                  : DriveOSPullToRefresh(
                      key: const ValueKey('dashboard_content'),
                      skeleton: const DriveOSSkeletonDetail(),
                      onRefresh: vm.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                        children: [
                          if (vm.error != null)
                            AuthErrorBanner(message: vm.error!),
                          if (dtcAlertsCount > 0) ...[
                            DtcAlertBanner(
                              alertCount: dtcAlertsCount,
                              onDetailsPressed: widget.onNavigateToIot,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: _AdminKpiCard(
                                  label: loc.translate('total_revenue'),
                                  value:
                                      'S/ ${totalRevenue.toStringAsFixed(0)}',
                                  icon: Icons.payments_outlined,
                                  color: DriveOSColors.primaryBlue,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AdminKpiCard(
                                  label: loc.translate('completed_orders'),
                                  value: '$completedOrders',
                                  icon: Icons.task_alt_rounded,
                                  color: DriveOSColors.preventiveGreen,
                                  onTap: widget.onNavigateToOrders,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: _AdminKpiCard(
                                  label: loc.translate('appointments_count'),
                                  value: '$appointmentsCount',
                                  icon: Icons.calendar_month_outlined,
                                  color: DriveOSColors.secondaryTeal,
                                  onTap: widget.onNavigateToAppointments,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _AdminKpiCard(
                                  label: loc.translate('low_stock_alerts'),
                                  value: '$lowStockCount',
                                  icon: Icons.inventory_2_outlined,
                                  color: DriveOSColors.severityAmber,
                                  onTap: widget.onNavigateToInventory,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            loc.translate('quick_actions'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: DriveOSColors.graphiteText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              ActionChip(
                                avatar: const Icon(
                                  Icons.build_outlined,
                                  size: 18,
                                ),
                                label: Text(loc.translate('orders_tab')),
                                onPressed: widget.onNavigateToOrders,
                              ),
                              ActionChip(
                                avatar: const Icon(
                                  Icons.calendar_month_outlined,
                                  size: 18,
                                ),
                                label: Text(loc.translate('appointments_tab')),
                                onPressed: widget.onNavigateToAppointments,
                              ),
                              ActionChip(
                                avatar: const Icon(
                                  Icons.inventory_2_outlined,
                                  size: 18,
                                ),
                                label: Text(loc.translate('inventory_tab')),
                                onPressed: widget.onNavigateToInventory,
                              ),
                              ActionChip(
                                avatar: const Icon(
                                  Icons.sensors_outlined,
                                  size: 18,
                                ),
                                label: Text(loc.translate('telemetry_tab')),
                                onPressed: widget.onNavigateToIot,
                              ),
                            ],
                          ),
                          if (vm.revenueTrend.isNotEmpty) ...[
                            const SizedBox(height: 22),
                            Text(
                              loc.translate('revenue_trend'),
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: DriveOSColors.graphiteText,
                              ),
                            ),
                            const SizedBox(height: 10),
                            ...vm.revenueTrend.take(6).map(
                                  (point) => Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: DriveOSColors.borderSlate,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          point.period,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                            color: DriveOSColors.graphiteText,
                                          ),
                                        ),
                                        Text(
                                          'S/ ${point.grossRevenue.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: DriveOSColors.primaryBlue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          ],
                        ],
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _AdminKpiCard extends StatelessWidget {
  const _AdminKpiCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DriveOSTactileCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DriveOSColors.borderSlate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: DriveOSColors.graphiteText,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 12,
                color: DriveOSColors.graphiteText.withValues(alpha: 0.65),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
