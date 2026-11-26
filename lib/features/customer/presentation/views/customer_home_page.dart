import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_floating_nav_bar.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_loading_helpers.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_tactile_card.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_toast.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/billing/domain/billing_domain.dart';
import 'package:mobile_application_driveos/features/customer/presentation/controllers/customer_home_view_model.dart';
import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';

/// Dedicated mobile portal shell for `CUSTOMER` accounts using
/// [DriveOSFloatingNavBar].
class CustomerHomePage extends StatefulWidget {
  /// Optional injected [CustomerHomeViewModel] for testing.
  final CustomerHomeViewModel? viewModel;

  /// Creates a [CustomerHomePage].
  const CustomerHomePage({super.key, this.viewModel});

  @override
  State<CustomerHomePage> createState() => _CustomerHomePageState();
}

class _CustomerHomePageState extends State<CustomerHomePage> {
  CustomerHomeViewModel? _viewModel;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel;
    } else if (getIt.isRegistered<CustomerHomeViewModel>()) {
      _viewModel = getIt<CustomerHomeViewModel>();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel?.load();
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
    final vm = _viewModel;

    return ListenableBuilder(
      listenable: vm ?? ValueNotifier<int>(0),
      builder: (context, _) {
        return Scaffold(
          extendBody: true,
          backgroundColor: DriveOSColors.warmNeutral,
          body: DriveOSCollapsibleHeaderBody(
            header: DriveOSPageHeader(
              title: loc.translate('customer_portal_title'),
              actions: [
                IconButton(
                  tooltip: loc.translate('sign_out'),
                  icon: const Icon(Icons.logout_rounded, color: Colors.white),
                  onPressed: _signOut,
                ),
              ],
            ),
            body: DriveOSContentTransition(
              child: (vm?.isLoading ?? false) &&
                      (vm?.workOrders.isEmpty ?? true)
                  ? const DriveOSSkeletonDetail(
                      key: ValueKey('customer_skeleton'),
                    )
                  : IndexedStack(
                      key: const ValueKey('customer_tabs'),
                      index: _selectedTab,
                      children: [
                        _SummaryTab(
                          vm: vm,
                          onSelectTab: (tab) =>
                              setState(() => _selectedTab = tab),
                        ),
                        _VehiclesTab(vehicles: vm?.vehicles ?? const []),
                        _OrdersTab(orders: vm?.workOrders ?? const []),
                        _QuotesTab(
                          quotes: vm?.quotes ?? const [],
                          busyQuoteId: vm?.busyQuoteId,
                          onApprove: (id) async {
                            final ok = await vm?.approveQuote(id) ?? false;
                            if (ok && context.mounted) {
                              DriveOSToast.show(
                                context,
                                loc.translate('approve_quote'),
                                type: DriveOSToastType.success,
                              );
                            }
                          },
                          onReject: (id) async {
                            final ok = await vm?.rejectQuote(id) ?? false;
                            if (ok && context.mounted) {
                              DriveOSToast.show(
                                context,
                                loc.translate('reject_quote'),
                                type: DriveOSToastType.info,
                              );
                            }
                          },
                        ),
                      ],
                    ),
            ),
          ),
          bottomNavigationBar: DriveOSFloatingNavBar(
            key: const Key('customer_navigation_bar'),
            selectedIndex: _selectedTab,
            onDestinationSelected: (index) =>
                setState(() => _selectedTab = index),
            items: [
              DriveOSNavItem(
                key: const Key('customer_nav_home'),
                icon: Icons.home_outlined,
                selectedIcon: Icons.home_rounded,
                label: loc.translate('customer_home_tab'),
              ),
              DriveOSNavItem(
                key: const Key('customer_nav_vehicles'),
                icon: Icons.directions_car_outlined,
                selectedIcon: Icons.directions_car_rounded,
                label: loc.translate('customer_vehicles_tab'),
              ),
              DriveOSNavItem(
                key: const Key('customer_nav_orders'),
                icon: Icons.build_outlined,
                selectedIcon: Icons.build_rounded,
                label: loc.translate('customer_orders_tab'),
              ),
              DriveOSNavItem(
                key: const Key('customer_nav_quotes'),
                icon: Icons.receipt_long_outlined,
                selectedIcon: Icons.receipt_long_rounded,
                label: loc.translate('customer_payments_tab'),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryTab extends StatelessWidget {
  const _SummaryTab({required this.vm, required this.onSelectTab});

  final CustomerHomeViewModel? vm;
  final ValueChanged<int> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final summary = vm?.summary;
    final vehicleCount = summary?.activeVehiclesCount ?? vm?.vehicles.length ?? 0;
    final orderCount =
        summary?.activeWorkOrdersCount ?? vm?.workOrders.length ?? 0;
    final quoteCount = summary?.pendingQuotesCount ?? vm?.quotes.length ?? 0;

    return DriveOSPullToRefresh(
      skeleton: const DriveOSSkeletonDetail(),
      onRefresh: () => vm?.load() ?? Future.value(),
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Row(
            children: [
              Expanded(
                child: _KpiTile(
                  label: loc.translate('customer_my_vehicles'),
                  value: '$vehicleCount',
                  icon: Icons.directions_car_outlined,
                  color: DriveOSColors.primaryBlue,
                  onTap: () => onSelectTab(1),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _KpiTile(
                  label: loc.translate('customer_active_orders'),
                  value: '$orderCount',
                  icon: Icons.build_outlined,
                  color: DriveOSColors.secondaryTeal,
                  onTap: () => onSelectTab(2),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _KpiTile(
            label: loc.translate('customer_pending_quotes'),
            value: '$quoteCount',
            icon: Icons.receipt_long_outlined,
            color: DriveOSColors.severityAmber,
            onTap: () => onSelectTab(3),
          ),
        ],
      ),
    );
  }
}

class _KpiTile extends StatelessWidget {
  const _KpiTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DriveOSTactileCard(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: DriveOSColors.borderSlate),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: DriveOSColors.graphiteText,
                    ),
                  ),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          DriveOSColors.graphiteText.withValues(alpha: 0.65),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehiclesTab extends StatelessWidget {
  const _VehiclesTab({required this.vehicles});

  final List<Vehicle> vehicles;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (vehicles.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DriveOSEmptyStateIcon(
              icon: Icons.directions_car_outlined,
              color: DriveOSColors.primaryBlue,
            ),
            const SizedBox(height: 14),
            Text(
              loc.translate('customer_no_vehicles'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: DriveOSColors.graphiteText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: vehicles.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final v = vehicles[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DriveOSColors.borderSlate),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.directions_car_rounded,
                color: DriveOSColors.primaryBlue,
                size: 28,
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${v.brand} ${v.model} (${v.year})',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: DriveOSColors.graphiteText,
                      ),
                    ),
                    Text(
                      v.plate,
                      style: TextStyle(
                        fontSize: 13,
                        color:
                            DriveOSColors.graphiteText.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _OrdersTab extends StatelessWidget {
  const _OrdersTab({required this.orders});

  final List<WorkOrder> orders;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DriveOSEmptyStateIcon(
              icon: Icons.build_outlined,
              color: DriveOSColors.secondaryTeal,
            ),
            const SizedBox(height: 14),
            Text(
              loc.translate('customer_no_orders'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: DriveOSColors.graphiteText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DriveOSColors.borderSlate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.number,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: DriveOSColors.primaryBlue,
                    ),
                  ),
                  Text(
                    order.status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: DriveOSColors.graphiteText,
                    ),
                  ),
                ],
              ),
              if (order.diagnosis != null && order.diagnosis!.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  order.diagnosis!,
                  style: TextStyle(
                    fontSize: 13,
                    color: DriveOSColors.graphiteText.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _QuotesTab extends StatelessWidget {
  const _QuotesTab({
    required this.quotes,
    required this.busyQuoteId,
    required this.onApprove,
    required this.onReject,
  });

  final List<Quote> quotes;
  final String? busyQuoteId;
  final ValueChanged<String> onApprove;
  final ValueChanged<String> onReject;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    if (quotes.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const DriveOSEmptyStateIcon(
              icon: Icons.receipt_long_outlined,
              color: DriveOSColors.severityAmber,
            ),
            const SizedBox(height: 14),
            Text(
              loc.translate('customer_no_quotes'),
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: DriveOSColors.graphiteText,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemCount: quotes.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final q = quotes[index];
        final isPending = q.status.toUpperCase() == 'PENDING';
        final isBusy = busyQuoteId == q.id;
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: DriveOSColors.borderSlate),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'S/ ${q.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: DriveOSColors.graphiteText,
                    ),
                  ),
                  Text(
                    q.status,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: DriveOSColors.primaryBlue,
                    ),
                  ),
                ],
              ),
              if (isPending) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: isBusy ? null : () => onReject(q.id),
                        child: Text(loc.translate('reject_quote')),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton(
                        onPressed: isBusy ? null : () => onApprove(q.id),
                        child: Text(loc.translate('approve_quote')),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
