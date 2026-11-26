import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_kanban_tab_bar.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_loading_helpers.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_page_header.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_pull_to_refresh.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_skeleton.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mobile_application_driveos/features/fleet/domain/fleet_domain.dart';
import 'package:mobile_application_driveos/features/fleet/presentation/controllers/appointments_view_model.dart';

/// Workshop appointments agenda page with status tabs and lifecycle actions.
class AppointmentsPage extends StatefulWidget {
  /// Optional injected [AppointmentsViewModel] for testing.
  final AppointmentsViewModel? viewModel;

  /// Optional explicit branch identifier override.
  final String? branchId;

  /// Creates an [AppointmentsPage].
  const AppointmentsPage({
    super.key,
    this.viewModel,
    this.branchId,
  });

  @override
  State<AppointmentsPage> createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {
  static const List<String?> _tabStatuses = [
    null,
    'SCHEDULED',
    'CONFIRMED',
    'COMPLETED',
  ];

  late final AppointmentsViewModel _viewModel;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<AppointmentsViewModel>();
    _tabController = TabController(length: _tabStatuses.length, vsync: this);
    _tabController.addListener(_handleTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadAppointments(widget.branchId);
    });
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) return;
    _viewModel.filterByStatus(_tabStatuses[_tabController.index]);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showCreateAppointmentDialog() async {
    final customerController = TextEditingController();
    final vehicleController = TextEditingController();
    final notesController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('new_appointment')),
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
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
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
              final now = DateTime.now().add(const Duration(hours: 1));
              final ok = await _viewModel.scheduleAppointment(
                customerId: customerController.text,
                vehicleId: vehicleController.text,
                scheduledStart: now,
                scheduledEnd: now.add(const Duration(hours: 1)),
                notes: notesController.text,
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
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('fab_new_appointment'),
            onPressed: _showCreateAppointmentDialog,
            icon: const Icon(Icons.add_rounded),
            label: Text(loc.translate('new_appointment')),
          ),
          body: DriveOSCollapsibleHeaderBody(
            header: DriveOSPageHeader(
              title: loc.translate('appointments_title'),
            ),
            body: Column(
              children: [
                DriveOSKanbanTabBar(
                  controller: _tabController,
                  tabs: [
                    DriveOSKanbanTabItem(
                      label: loc.translate('all_tab'),
                      count: vm.appointments.length,
                    ),
                    DriveOSKanbanTabItem(
                      label: loc.translate('scheduled_status'),
                    ),
                    DriveOSKanbanTabItem(
                      label: loc.translate('confirmed_status'),
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
                    child: vm.isLoading && vm.appointments.isEmpty
                        ? const DriveOSSkeletonCardList(
                            key: ValueKey('appointments_skeleton'),
                          )
                        : vm.appointments.isEmpty
                            ? Center(
                                key: const ValueKey('appointments_empty'),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const DriveOSEmptyStateIcon(
                                      icon: Icons.calendar_month_outlined,
                                      color: DriveOSColors.secondaryTeal,
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      loc.translate('no_appointments'),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: DriveOSColors.graphiteText,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : DriveOSPullToRefresh(
                                key: const ValueKey('appointments_list'),
                                onRefresh: () =>
                                    vm.loadAppointments(widget.branchId),
                                child: ListView.separated(
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.fromLTRB(
                                    16,
                                    16,
                                    16,
                                    110,
                                  ),
                                  itemCount: vm.appointments.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final appt = vm.appointments[index];
                                    return _AppointmentCard(
                                      appointment: appt,
                                      onConfirm: () => vm.confirm(appt.id),
                                      onCheckIn: () => vm.checkIn(appt.id),
                                      onComplete: () => vm.complete(appt.id),
                                      onCancel: () =>
                                          vm.cancelAppointment(appt.id),
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

class _AppointmentCard extends StatelessWidget {
  const _AppointmentCard({
    required this.appointment,
    required this.onConfirm,
    required this.onCheckIn,
    required this.onComplete,
    required this.onCancel,
  });

  final Appointment appointment;
  final VoidCallback onConfirm;
  final VoidCallback onCheckIn;
  final VoidCallback onComplete;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final status = appointment.status.toUpperCase();
    final timeRange =
        '${DateFormat('MMM d, HH:mm').format(appointment.scheduledStart)} - '
        '${DateFormat('HH:mm').format(appointment.scheduledEnd)}';

    return Container(
      key: Key('appointment_card_${appointment.id}'),
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
                timeRange,
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  color: DriveOSColors.primaryBlue,
                ),
              ),
              Text(
                appointment.status,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: DriveOSColors.graphiteText,
                ),
              ),
            ],
          ),
          if (appointment.notes != null && appointment.notes!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              appointment.notes!,
              style: TextStyle(
                fontSize: 13.5,
                color: DriveOSColors.graphiteText.withValues(alpha: 0.72),
              ),
            ),
          ],
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (status == 'SCHEDULED' || status == 'PENDING')
                OutlinedButton(
                  onPressed: onConfirm,
                  child: Text(loc.translate('confirm_appointment')),
                ),
              if (status == 'CONFIRMED')
                OutlinedButton(
                  onPressed: onCheckIn,
                  child: Text(loc.translate('checkin_appointment')),
                ),
              if (status == 'CHECKED_IN' || status == 'CONFIRMED')
                FilledButton(
                  onPressed: onComplete,
                  child: Text(loc.translate('complete_appointment')),
                ),
              if (status != 'COMPLETED' && status != 'CANCELLED')
                TextButton(
                  onPressed: onCancel,
                  child: Text(loc.translate('cancel_appointment')),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
