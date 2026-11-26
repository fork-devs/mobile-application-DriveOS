import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_loading_helpers.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_tactile_card.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/controllers/employee_dashboard_view_model.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/widgets/dtc_alert_banner.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';

/// Personal operational dashboard for workshop technicians (`TECHNICIAN`).
class EmployeeDashboardPage extends StatefulWidget {
  /// Optional injected [EmployeeDashboardViewModel] for testing.
  final EmployeeDashboardViewModel? viewModel;

  /// Callback to switch to the Orders tab.
  final VoidCallback? onNavigateToOrders;

  /// Callback to switch to the Telemetry tab.
  final VoidCallback? onNavigateToTelemetry;

  /// Creates an [EmployeeDashboardPage].
  const EmployeeDashboardPage({
    super.key,
    this.viewModel,
    this.onNavigateToOrders,
    this.onNavigateToTelemetry,
  });

  @override
  State<EmployeeDashboardPage> createState() => _EmployeeDashboardPageState();
}

class _EmployeeDashboardPageState extends State<EmployeeDashboardPage> {
  late final EmployeeDashboardViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<EmployeeDashboardViewModel>();
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
        final summary = vm.summary;
        final assignedOrders = summary?.assignedWorkOrders ?? const [];

        return Scaffold(
          backgroundColor: DriveOSColors.warmNeutral,
          body: DriveOSCollapsibleHeaderBody(
            header: DriveOSPageHeader(
              title: loc.translate('my_summary'),
              subtitle: vm.activeBranchName,
              actions: [
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
                      key: ValueKey('employee_dashboard_skeleton'),
                    )
                  : DriveOSPullToRefresh(
                      key: const ValueKey('employee_dashboard_content'),
                      skeleton: const DriveOSSkeletonDetail(),
                      onRefresh: vm.refresh,
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 110),
                        children: [
                          if (vm.error != null)
                            AuthErrorBanner(message: vm.error!),
                          if (summary != null &&
                              summary.activeDtcAlertsCount > 0) ...[
                            DtcAlertBanner(
                              alertCount: summary.activeDtcAlertsCount,
                              onDetailsPressed: widget.onNavigateToTelemetry,
                            ),
                            const SizedBox(height: 16),
                          ],
                          Row(
                            children: [
                              Expanded(
                                child: _TechKpiCard(
                                  label: loc.translate('assigned_orders'),
                                  value:
                                      '${summary?.assignedWorkOrdersCount ?? 0}',
                                  color: DriveOSColors.primaryBlue,
                                  onTap: widget.onNavigateToOrders,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _TechKpiCard(
                                  label: loc.translate('pending_tasks'),
                                  value: '${summary?.pendingTasksCount ?? 0}',
                                  color: DriveOSColors.severityAmber,
                                  onTap: widget.onNavigateToOrders,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _TechKpiCard(
                                  label: loc.translate('completed_tasks'),
                                  value: '${summary?.completedTasksCount ?? 0}',
                                  color: DriveOSColors.preventiveGreen,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            loc.translate('assigned_work_orders_title'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: DriveOSColors.graphiteText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (assignedOrders.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 28),
                              child: Column(
                                children: [
                                  const DriveOSEmptyStateIcon(
                                    icon: Icons.build_outlined,
                                    color: DriveOSColors.primaryBlue,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    loc.translate('no_assigned_orders'),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: DriveOSColors.graphiteText,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            ...assignedOrders.map((item) {
                              final number =
                                  item['number']?.toString() ?? 'Work Order';
                              final status = item['status']?.toString() ?? '';
                              final diagnosis =
                                  item['diagnosis']?.toString() ?? '';
                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: DriveOSColors.borderSlate,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          number,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            color: DriveOSColors.primaryBlue,
                                          ),
                                        ),
                                        Text(
                                          status,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: DriveOSColors.graphiteText,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (diagnosis.isNotEmpty) ...[
                                      const SizedBox(height: 6),
                                      Text(
                                        diagnosis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: DriveOSColors.graphiteText
                                              .withValues(alpha: 0.72),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }),
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

class _TechKpiCard extends StatelessWidget {
  const _TechKpiCard({
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return DriveOSTactileCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: DriveOSColors.borderSlate),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11.5,
                color: DriveOSColors.graphiteText.withValues(alpha: 0.68),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
