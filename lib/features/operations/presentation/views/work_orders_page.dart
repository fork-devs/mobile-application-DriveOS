import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_kanban_tab_bar.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_loading_helpers.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_tactile_card.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';
import 'package:mobile_application_driveos/features/operations/presentation/controllers/work_orders_view_model.dart';
import 'package:mobile_application_driveos/features/operations/presentation/views/work_order_detail_page.dart';

/// Filterable workshop work orders list for `WORKSHOP_ADMIN` and `TECHNICIAN`.
class WorkOrdersPage extends StatefulWidget {
  /// Optional injected [WorkOrdersViewModel] for testing.
  final WorkOrdersViewModel? viewModel;

  /// Optional explicit role scope override.
  final MobileRoleScope? roleScope;

  /// Creates a [WorkOrdersPage].
  const WorkOrdersPage({
    super.key,
    this.viewModel,
    this.roleScope,
  });

  @override
  State<WorkOrdersPage> createState() => _WorkOrdersPageState();
}

class _WorkOrdersPageState extends State<WorkOrdersPage>
    with SingleTickerProviderStateMixin {
  static const List<String?> _tabStatuses = [
    null,
    'OPEN',
    'IN_PROGRESS',
    'COMPLETED',
  ];

  late final WorkOrdersViewModel _viewModel;
  late final TabController _tabController;

  bool get _canCreateWorkOrder {
    if (widget.roleScope != null) {
      return widget.roleScope == MobileRoleScope.workshopAdmin;
    }
    if (getIt.isRegistered<SessionStorage>()) {
      return RoleRouter.resolveScopeOrNull(getIt<SessionStorage>().roles) ==
          MobileRoleScope.workshopAdmin;
    }
    return false;
  }

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<WorkOrdersViewModel>();
    _tabController = TabController(length: _tabStatuses.length, vsync: this);
    _tabController.addListener(_handleTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.init();
    });
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) return;
    _viewModel.setFilter(_tabStatuses[_tabController.index]);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showOpenOrderDialog() async {
    final customerController = TextEditingController();
    final vehicleController = TextEditingController();
    final diagnosisController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('new_work_order')),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: customerController,
                decoration: const InputDecoration(labelText: 'Customer ID'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: vehicleController,
                decoration: const InputDecoration(labelText: 'Vehicle ID'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: diagnosisController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Diagnosis'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(AppLocalizations.of(context).translate('cancel')),
          ),
          FilledButton(
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final ok = await _viewModel.openOrder(
                customerId: customerController.text,
                vehicleId: vehicleController.text,
                diagnosis: diagnosisController.text,
              );
              if (ok && dialogContext.mounted) {
                Navigator.of(dialogContext).pop();
              }
            },
            child: Text(AppLocalizations.of(context).translate('save')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final vm = _viewModel;

        return Scaffold(
          backgroundColor: DriveOSColors.warmNeutral,
          floatingActionButton: _canCreateWorkOrder
              ? FloatingActionButton.extended(
                  key: const Key('fab_new_work_order'),
                  onPressed: _showOpenOrderDialog,
                  icon: const Icon(Icons.add_rounded),
                  label: Text(loc.translate('new_work_order')),
                )
              : null,
          body: DriveOSCollapsibleHeaderBody(
            header: DriveOSPageHeader(
              title: loc.translate('work_orders_title'),
              subtitle: vm.activeBranchName,
            ),
            body: Column(
              children: [
                DriveOSKanbanTabBar(
                  controller: _tabController,
                  tabs: [
                    DriveOSKanbanTabItem(
                      label: loc.translate('all_tab'),
                      count: vm.orders.length,
                    ),
                    DriveOSKanbanTabItem(label: loc.translate('open_status')),
                    DriveOSKanbanTabItem(
                      label: loc.translate('in_progress_status'),
                    ),
                    DriveOSKanbanTabItem(
                      label: loc.translate('completed_status'),
                    ),
                  ],
                ),
                if (vm.errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: AuthErrorBanner(message: vm.errorMessage!),
                  ),
                Expanded(
                  child: DriveOSContentTransition(
                    child: vm.isLoading && vm.orders.isEmpty
                        ? const DriveOSSkeletonCardList(
                            key: ValueKey('orders_skeleton'),
                          )
                        : vm.orders.isEmpty
                            ? Center(
                                key: const ValueKey('orders_empty'),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const DriveOSEmptyStateIcon(
                                      icon: Icons.build_outlined,
                                      color: DriveOSColors.primaryBlue,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      loc.translate('no_work_orders'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: DriveOSColors.graphiteText,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : DriveOSPullToRefresh(
                                key: const ValueKey('orders_list'),
                                onRefresh: vm.loadOrders,
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    110,
                                  ),
                                  itemCount: vm.orders.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final order = vm.orders[index];
                                    return _WorkOrderCard(
                                      order: order,
                                      onTap: () async {
                                        await Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) => WorkOrderDetailPage(
                                              workOrderId: order.orderId,
                                            ),
                                          ),
                                        );
                                        vm.loadOrders();
                                      },
                                    );
                                  },
                                ),
                              ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WorkOrderCard extends StatelessWidget {
  const _WorkOrderCard({required this.order, required this.onTap});

  final WorkOrder order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return DriveOSTactileCard(
      onTap: onTap,
      child: Container(
        key: Key('work_order_card_${order.orderId}'),
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
                    fontSize: 15.5,
                    fontWeight: FontWeight.w800,
                    color: DriveOSColors.primaryBlue,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: DriveOSColors.primaryBlue.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.status,
                    style: const TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: DriveOSColors.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
            if (order.diagnosis != null && order.diagnosis!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                order.diagnosis!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5,
                  color: DriveOSColors.graphiteText.withValues(alpha: 0.72),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
