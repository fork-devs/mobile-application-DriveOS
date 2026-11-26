import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_top_progress_bar.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mobile_application_driveos/features/iot/domain/iot_domain.dart';
import 'package:mobile_application_driveos/features/iot/presentation/controllers/telemetry_view_model.dart';

/// Workshop IoT & OBD2 telemetry dashboard showing registered devices, active
/// vehicle links, and severity-filtered DTC alerts.
class TelemetryDashboardPage extends StatefulWidget {
  /// Optional injected [TelemetryViewModel] for testing.
  final TelemetryViewModel? viewModel;

  /// Optional explicit branch identifier override.
  final String? branchId;

  /// Creates a [TelemetryDashboardPage].
  const TelemetryDashboardPage({
    super.key,
    this.viewModel,
    this.branchId,
  });

  @override
  State<TelemetryDashboardPage> createState() => _TelemetryDashboardPageState();
}

class _TelemetryDashboardPageState extends State<TelemetryDashboardPage>
    with SingleTickerProviderStateMixin {
  static const List<String?> _severities = [
    null,
    'CRITICAL',
    'WARNING',
  ];

  late final TelemetryViewModel _viewModel;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<TelemetryViewModel>();
    _tabController = TabController(length: _severities.length, vsync: this);
    _tabController.addListener(_handleTabChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _viewModel.loadTelemetry(widget.branchId);
    });
  }

  void _handleTabChanged() {
    if (_tabController.indexIsChanging) return;
    _viewModel.filterBySeverity(_severities[_tabController.index]);
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _showRegisterDeviceDialog() async {
    final macController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context).translate('register_obd2')),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: macController,
            decoration: const InputDecoration(
              labelText: 'MAC Address',
              hintText: 'AA:BB:CC:11:22:33',
            ),
            validator: (v) =>
                v == null || v.trim().isEmpty ? 'Required' : null,
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
              final ok = await _viewModel.registerDevice(macController.text);
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
          appBar: AppBar(
            title: Text(loc.translate('telemetry_title')),
            bottom: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabs: [
                Tab(text: loc.translate('all_tab')),
                Tab(text: loc.translate('critical_severity')),
                Tab(text: loc.translate('warning_severity')),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton.extended(
            key: const Key('fab_register_obd2'),
            onPressed: _showRegisterDeviceDialog,
            icon: const Icon(Icons.bluetooth_searching_rounded),
            label: Text(loc.translate('register_obd2')),
          ),
          body: Column(
            children: [
              DriveOSTopProgressBar(isLoading: vm.isLoading),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: _TelemetryStatTile(
                        label: loc.translate('obd2_devices_count'),
                        value: '${vm.devices.length}',
                        color: DriveOSColors.primaryBlue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _TelemetryStatTile(
                        label: loc.translate('active_links_count'),
                        value: '${vm.registrations.length}',
                        color: DriveOSColors.secondaryTeal,
                      ),
                    ),
                  ],
                ),
              ),
              if (vm.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
                  child: AuthErrorBanner(message: vm.errorMessage!),
                ),
              Expanded(
                child: vm.dtcAlerts.isEmpty && !vm.isLoading
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const DriveOSEmptyStateIcon(
                              icon: Icons.sensors_outlined,
                              color: DriveOSColors.secondaryTeal,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              loc.translate('no_dtc_alerts'),
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                color: DriveOSColors.graphiteText,
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => vm.loadTelemetry(widget.branchId),
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                          itemCount: vm.dtcAlerts.length,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) =>
                              _DtcAlertCard(alert: vm.dtcAlerts[index]),
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

class _TelemetryStatTile extends StatelessWidget {
  const _TelemetryStatTile({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
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
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: DriveOSColors.graphiteText.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

class _DtcAlertCard extends StatelessWidget {
  const _DtcAlertCard({required this.alert});

  final DtcAlert alert;

  @override
  Widget build(BuildContext context) {
    final isCritical = alert.severity.toUpperCase() == 'CRITICAL' ||
        alert.severity.toUpperCase() == 'HIGH';
    final badgeColor = isCritical
        ? DriveOSColors.severityCrimson
        : DriveOSColors.severityAmber;

    return Container(
      key: Key('dtc_alert_card_${alert.id}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                alert.dtcCode,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: badgeColor,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  alert.severity,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            alert.description,
            style: TextStyle(
              fontSize: 13.5,
              color: DriveOSColors.graphiteText.withValues(alpha: 0.78),
            ),
          ),
        ],
      ),
    );
  }
}
