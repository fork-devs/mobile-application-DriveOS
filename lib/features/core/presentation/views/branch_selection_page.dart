import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_primary_pill_button.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_top_progress_bar.dart';
import 'package:mobile_application_driveos/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';
import 'package:mobile_application_driveos/features/core/presentation/controllers/branch_selection_view_model.dart';
import 'package:mobile_application_driveos/features/core/presentation/widgets/branch_list_card.dart';
import 'package:mobile_application_driveos/features/core/presentation/widgets/branch_location_picker.dart';
import 'package:mobile_application_driveos/features/core/presentation/widgets/branch_map_view.dart';

/// Multi-branch selector featuring animated MapLibre pins and a list/map toggle.
class BranchSelectionPage extends StatefulWidget {
  /// Optional injected [BranchSelectionViewModel] for testing.
  final BranchSelectionViewModel? viewModel;

  /// Whether to open on the interactive map view initially.
  final bool initialShowMap;

  /// Creates a [BranchSelectionPage].
  const BranchSelectionPage({
    super.key,
    this.viewModel,
    this.initialShowMap = true,
  });

  @override
  State<BranchSelectionPage> createState() => _BranchSelectionPageState();
}

class _BranchSelectionPageState extends State<BranchSelectionPage> {
  late final BranchSelectionViewModel _viewModel;
  late bool _showMap = widget.initialShowMap;
  bool _isAutoEntering = false;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModel ?? getIt<BranchSelectionViewModel>();
    WidgetsBinding.instance.addPostFrameCallback((_) => _initBranches());
  }

  Future<void> _initBranches() async {
    await _viewModel.loadBranches();
    if (!mounted) return;
    if (_roleScope == MobileRoleScope.technician &&
        _viewModel.branches.length == 1) {
      setState(() => _isAutoEntering = true);
      await _onBranchSelected(_viewModel.branches.first);
    }
  }

  MobileRoleScope get _roleScope {
    if (getIt.isRegistered<SessionStorage>()) {
      return RoleRouter.resolveScopeOrNull(getIt<SessionStorage>().roles) ??
          MobileRoleScope.technician;
    }
    return MobileRoleScope.technician;
  }

  Future<void> _onBranchSelected(Branch branch) async {
    final success = await _viewModel.selectBranch(branch);
    if (success && mounted) {
      context.go('/main');
    }
  }

  void _showBranchFormModal(
    BuildContext context, {
    required String workshopId,
    Branch? existingBranch,
  }) {
    final loc = AppLocalizations.of(context);
    final isEditing = existingBranch != null;
    final codeController =
        TextEditingController(text: existingBranch?.code ?? '');
    final nameController =
        TextEditingController(text: existingBranch?.name ?? '');
    final addressController =
        TextEditingController(text: existingBranch?.address ?? '');
    final phoneController =
        TextEditingController(text: existingBranch?.phone ?? '');
    final formKey = GlobalKey<FormState>();

    double? pickedLat = existingBranch?.latitude;
    double? pickedLng = existingBranch?.longitude;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        isEditing
                            ? loc.translate('edit_branch')
                            : loc.translate('new_branch'),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: DriveOSColors.graphiteText,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: codeController,
                        decoration: authInputDecoration(
                          hintText: loc.translate('branch_code'),
                          prefixIcon: Icons.qr_code_rounded,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: nameController,
                        decoration: authInputDecoration(
                          hintText: loc.translate('branch_name'),
                          prefixIcon: Icons.storefront_outlined,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: addressController,
                        decoration: authInputDecoration(
                          hintText: loc.translate('branch_address'),
                          prefixIcon: Icons.place_outlined,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: authInputDecoration(
                          hintText: loc.translate('branch_phone'),
                          prefixIcon: Icons.phone_outlined,
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.map_outlined),
                        label: Text(
                          pickedLat != null && pickedLng != null
                              ? '${loc.translate('location_selected')}: '
                                  '${pickedLat!.toStringAsFixed(4)}, '
                                  '${pickedLng!.toStringAsFixed(4)}'
                              : loc.translate('pick_location'),
                        ),
                        onPressed: () async {
                          final picked = await Navigator.of(context).push<LatLng>(
                            MaterialPageRoute(
                              builder: (_) => BranchLocationPicker(
                                initialLatitude: pickedLat,
                                initialLongitude: pickedLng,
                                onLocationPicked: (coords) {},
                              ),
                            ),
                          );
                          if (picked != null) {
                            setModalState(() {
                              pickedLat = picked.latitude;
                              pickedLng = picked.longitude;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 18),
                      DriveOSPrimaryPillButton(
                        label: loc.translate('save'),
                        onPressed: () async {
                          if (!formKey.currentState!.validate()) return;
                          final ok = isEditing
                              ? await _viewModel.updateBranch(
                                  branchId: existingBranch.id,
                                  code: codeController.text,
                                  name: nameController.text,
                                  address: addressController.text,
                                  phone: phoneController.text,
                                  latitude: pickedLat,
                                  longitude: pickedLng,
                                )
                              : await _viewModel.createBranch(
                                  workshopId: workshopId,
                                  code: codeController.text,
                                  name: nameController.text,
                                  address: addressController.text,
                                  phone: phoneController.text,
                                  latitude: pickedLat,
                                  longitude: pickedLng,
                                );
                          if (ok && sheetContext.mounted) {
                            Navigator.of(sheetContext).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final isAdmin = _roleScope == MobileRoleScope.workshopAdmin;

    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final workshopId = _viewModel.activeWorkshopId ?? '';

        return Scaffold(
          backgroundColor: DriveOSColors.warmNeutral,
          appBar: AppBar(
            title: Text(loc.translate('select_branch')),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: SegmentedButton<bool>(
                  segments: [
                    ButtonSegment<bool>(
                      value: true,
                      icon: const Icon(Icons.map_outlined, size: 17),
                      label: Text(loc.translate('map_view')),
                    ),
                    ButtonSegment<bool>(
                      value: false,
                      icon: const Icon(Icons.view_agenda_outlined, size: 17),
                      label: Text(loc.translate('list_view')),
                    ),
                  ],
                  selected: {_showMap},
                  onSelectionChanged: (selection) =>
                      setState(() => _showMap = selection.first),
                ),
              ),
            ],
          ),
          floatingActionButton: isAdmin && workshopId.isNotEmpty
              ? FloatingActionButton.extended(
                  onPressed: () =>
                      _showBranchFormModal(context, workshopId: workshopId),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(loc.translate('new_branch')),
                )
              : null,
          body: Column(
            children: [
              DriveOSTopProgressBar(
                isLoading: _viewModel.isLoading || _isAutoEntering,
              ),
              if (_viewModel.errorMessage != null)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: AuthErrorBanner(message: _viewModel.errorMessage!),
                ),
              Expanded(
                child: _viewModel.branches.isEmpty && !_viewModel.isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const DriveOSEmptyStateIcon(
                                icon: Icons.storefront_outlined,
                                color: DriveOSColors.primaryBlue,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                loc.translate('no_branches'),
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: DriveOSColors.graphiteText,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                loc.translate('no_branches_subtitle'),
                                style: TextStyle(
                                  fontSize: 13.5,
                                  color: DriveOSColors.graphiteText
                                      .withValues(alpha: 0.65),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : _showMap
                        ? BranchMapView(
                            branches: _viewModel.branches,
                            selectedBranch: _viewModel.selectedBranch,
                            onEnterBranch: _onBranchSelected,
                            onCreateBranch: isAdmin && workshopId.isNotEmpty
                                ? () => _showBranchFormModal(
                                      context,
                                      workshopId: workshopId,
                                    )
                                : null,
                          )
                        : RefreshIndicator(
                            onRefresh: _viewModel.loadBranches,
                            child: ListView.separated(
                              padding: const EdgeInsets.fromLTRB(
                                16,
                                16,
                                16,
                                96,
                              ),
                              itemCount: _viewModel.branches.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final branch = _viewModel.branches[index];
                                return BranchListCard(
                                  branch: branch,
                                  isFocused:
                                      _viewModel.selectedBranch?.id ==
                                          branch.id,
                                  isCurrentSession:
                                      _viewModel.selectedBranch?.id ==
                                          branch.id,
                                  onTap: () => _onBranchSelected(branch),
                                  onEnter: () => _onBranchSelected(branch),
                                  onEdit: isAdmin
                                      ? () => _showBranchFormModal(
                                            context,
                                            workshopId: branch.workshopId,
                                            existingBranch: branch,
                                          )
                                      : null,
                                );
                              },
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
