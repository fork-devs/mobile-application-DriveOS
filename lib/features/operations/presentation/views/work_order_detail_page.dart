import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_top_progress_bar.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mobile_application_driveos/features/operations/domain/operations_domain.dart';
import 'package:mobile_application_driveos/features/operations/presentation/controllers/work_order_detail_view_model.dart';

/// Detailed view of a single work order showing tasks, status transitions, and
/// vehicle photographic evidences.
class WorkOrderDetailPage extends StatefulWidget {
  /// Identifier of the work order to load.
  final String workOrderId;

  /// Optional injected [WorkOrderDetailViewModel] for testing.
  final WorkOrderDetailViewModel? viewModel;

  /// Whether editing actions should be hidden (customer read-only mode).
  final bool readOnly;

  /// Creates a [WorkOrderDetailPage].
  const WorkOrderDetailPage({
    super.key,
    required this.workOrderId,
    this.viewModel,
    this.readOnly = false,
  });

  @override
  State<WorkOrderDetailPage> createState() => _WorkOrderDetailPageState();
}

class _WorkOrderDetailPageState extends State<WorkOrderDetailPage> {
  late final WorkOrderDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<WorkOrderDetailViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadOrder(widget.workOrderId);
    });
  }

  Future<void> _showAddTaskDialog() async {
    final serviceController = TextEditingController();
    final descController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('add_task')),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: serviceController,
                decoration: const InputDecoration(labelText: 'Service ID'),
                validator: (v) =>
                    v == null || v.trim().isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: descController,
                decoration: const InputDecoration(labelText: 'Description'),
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
              final ok = await _viewModel.addTask(
                serviceId: serviceController.text,
                description: descController.text,
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
        final order = vm.order;

        return Scaffold(
          backgroundColor: DriveOSColors.warmNeutral,
          appBar: AppBar(
            title: Text(order?.number ?? loc.translate('work_order_detail')),
            actions: [
              if (!widget.readOnly &&
                  order != null &&
                  order.status.toUpperCase() != 'COMPLETED')
                TextButton(
                  onPressed: vm.completeWorkOrder,
                  child: Text(loc.translate('complete_order')),
                ),
            ],
          ),
          floatingActionButton: !widget.readOnly && order != null
              ? FloatingActionButton.extended(
                  onPressed: _showAddTaskDialog,
                  icon: const Icon(Icons.add_task_rounded),
                  label: Text(loc.translate('add_task')),
                )
              : null,
          body: Column(
            children: [
              DriveOSTopProgressBar(isLoading: vm.isLoading),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => vm.loadOrder(widget.workOrderId),
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                    children: [
                      if (vm.errorMessage != null)
                        AuthErrorBanner(message: vm.errorMessage!),
                      if (order != null) ...[
                        Container(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    order.number,
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: DriveOSColors.primaryBlue,
                                    ),
                                  ),
                                  Text(
                                    order.status,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      color: DriveOSColors.graphiteText,
                                    ),
                                  ),
                                ],
                              ),
                              if (order.diagnosis != null &&
                                  order.diagnosis!.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  order.diagnosis!,
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    color: DriveOSColors.graphiteText
                                        .withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          loc.translate('tasks_section'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: DriveOSColors.graphiteText,
                          ),
                        ),
                        const SizedBox(height: 10),
                        if (vm.tasks.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Column(
                              children: [
                                const DriveOSEmptyStateIcon(
                                  icon: Icons.checklist_rounded,
                                  color: DriveOSColors.primaryBlue,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  loc.translate('no_tasks'),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: DriveOSColors.graphiteText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ...vm.tasks.map(
                            (task) => _TaskCard(
                              task: task,
                              readOnly: widget.readOnly,
                              onStart: () => vm.startTask(task.id),
                              onComplete: () => vm.completeTask(task.id),
                              onReopen: () => vm.reopenTask(task.id),
                            ),
                          ),
                        if (vm.evidences.isNotEmpty) ...[
                          const SizedBox(height: 20),
                          Text(
                            loc.translate('evidences_section'),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: DriveOSColors.graphiteText,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ...vm.evidences.map(
                            (e) => Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: DriveOSColors.borderSlate,
                                ),
                              ),
                              child: Text(
                                '${e.stage}${e.caption != null ? ' · ${e.caption}' : ''}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: DriveOSColors.graphiteText,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TaskCard extends StatelessWidget {
  const _TaskCard({
    required this.task,
    required this.readOnly,
    required this.onStart,
    required this.onComplete,
    required this.onReopen,
  });

  final WorkOrderTask task;
  final bool readOnly;
  final VoidCallback onStart;
  final VoidCallback onComplete;
  final VoidCallback onReopen;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final status = task.status.toUpperCase();

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: DriveOSColors.borderSlate),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  task.description,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: DriveOSColors.graphiteText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                task.status,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: DriveOSColors.primaryBlue,
                ),
              ),
            ],
          ),
          if (!readOnly) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (status == 'PENDING')
                  OutlinedButton(
                    onPressed: onStart,
                    child: Text(loc.translate('start_task')),
                  ),
                if (status == 'DOING')
                  FilledButton(
                    onPressed: onComplete,
                    child: Text(loc.translate('complete_task')),
                  ),
                if (status == 'COMPLETED')
                  OutlinedButton(
                    onPressed: onReopen,
                    child: Text(loc.translate('reopen_task')),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
