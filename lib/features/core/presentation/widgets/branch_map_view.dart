import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_primary_pill_button.dart';
import 'package:mobile_application_driveos/features/core/domain/core_domain.dart';
import 'package:mobile_application_driveos/features/core/presentation/widgets/minimalist_map_config.dart';

/// Interactive MapLibre + OpenFreeMap Positron vector map displaying animated
/// branch pins and a compact floating branch preview card.
class BranchMapView extends StatefulWidget {
  /// All branches available for display.
  final List<Branch> branches;

  /// Currently selected branch, if any.
  final Branch? selectedBranch;

  /// Callback invoked when the user enters a branch from the preview card.
  final ValueChanged<Branch> onEnterBranch;

  /// Optional callback invoked when no geolocated branches exist yet.
  final VoidCallback? onCreateBranch;

  /// Creates a [BranchMapView].
  const BranchMapView({
    super.key,
    required this.branches,
    this.selectedBranch,
    required this.onEnterBranch,
    this.onCreateBranch,
  });

  @override
  State<BranchMapView> createState() => _BranchMapViewState();
}

class _BranchMapViewState extends State<BranchMapView>
    with SingleTickerProviderStateMixin {
  MapLibreMapController? _mapController;
  late final AnimationController _pulseController;
  Branch? _focusedBranch;
  bool _showCard = true;
  bool _styleLoaded = false;
  bool _updatingPositions = false;
  Map<String, math.Point<double>> _pinScreenPoints = {};

  List<Branch> get _geolocatedBranches => widget.branches
      .where((b) => b.latitude != null && b.longitude != null)
      .toList();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat();

    final geolocated = _geolocatedBranches;
    if (geolocated.isNotEmpty) {
      _focusedBranch = widget.selectedBranch != null &&
              widget.selectedBranch!.latitude != null &&
              widget.selectedBranch!.longitude != null
          ? widget.selectedBranch
          : geolocated.first;
    }
  }

  @override
  void didUpdateWidget(covariant BranchMapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.branches != widget.branches) {
      final geolocated = _geolocatedBranches;
      if (_focusedBranch == null && geolocated.isNotEmpty) {
        _focusedBranch = geolocated.first;
      }
      _updatePinScreenPositions();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _updatePinScreenPositions() async {
    final controller = _mapController;
    final geolocated = _geolocatedBranches;
    if (controller == null || !_styleLoaded || geolocated.isEmpty) return;
    if (_updatingPositions) return;

    _updatingPositions = true;
    try {
      final points = await controller.toScreenLocationBatch(
        geolocated.map((b) => LatLng(b.latitude!, b.longitude!)),
      );
      if (!mounted) return;

      final next = <String, math.Point<double>>{};
      for (var i = 0; i < geolocated.length && i < points.length; i++) {
        next[geolocated[i].id] = math.Point<double>(
          points[i].x.toDouble(),
          points[i].y.toDouble(),
        );
      }
      setState(() => _pinScreenPoints = next);
    } catch (_) {
      // Ignore transient projection calls before layout settles.
    } finally {
      _updatingPositions = false;
    }
  }

  Future<void> _focusBranch(Branch branch) async {
    setState(() {
      _focusedBranch = branch;
      _showCard = true;
    });
    if (_mapController != null &&
        branch.latitude != null &&
        branch.longitude != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(branch.latitude!, branch.longitude!),
          14.5,
        ),
      );
      await _updatePinScreenPositions();
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final geolocated = _geolocatedBranches;

    if (geolocated.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DriveOSEmptyStateIcon(
                icon: Icons.map_outlined,
                color: DriveOSColors.primaryBlue,
              ),
              const SizedBox(height: 16),
              Text(
                loc.translate('no_geolocated_branches'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: DriveOSColors.graphiteText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                loc.translate('no_geolocated_branches_subtitle'),
                style: TextStyle(
                  fontSize: 13.5,
                  color: DriveOSColors.graphiteText.withValues(alpha: 0.65),
                ),
                textAlign: TextAlign.center,
              ),
              if (widget.onCreateBranch != null) ...[
                const SizedBox(height: 18),
                DriveOSPrimaryPillButton(
                  icon: Icons.add_rounded,
                  label: loc.translate('new_branch'),
                  onPressed: widget.onCreateBranch,
                ),
              ],
            ],
          ),
        ),
      );
    }

    final initialTarget = LatLng(
      (_focusedBranch ?? geolocated.first).latitude!,
      (_focusedBranch ?? geolocated.first).longitude!,
    );

    return Stack(
      children: [
        MapLibreMap(
          styleString: MinimalistMapConfig.styleUrl,
          initialCameraPosition: CameraPosition(
            target: initialTarget,
            zoom: 13.5,
          ),
          trackCameraPosition: true,
          myLocationEnabled: false,
          onMapCreated: (controller) {
            _mapController = controller;
          },
          onStyleLoadedCallback: () {
            _styleLoaded = true;
            _updatePinScreenPositions();
          },
          onCameraIdle: _updatePinScreenPositions,
          onMapClick: (_, _) {
            if (_showCard) {
              setState(() => _showCard = false);
            }
          },
        ),
        ...geolocated.map((branch) {
          final point = _pinScreenPoints[branch.id];
          if (point == null) return const SizedBox.shrink();
          final isSelected = _focusedBranch?.id == branch.id;
          return Positioned(
            left: point.x - 18,
            top: point.y - 18,
            child: GestureDetector(
              onTap: () => _focusBranch(branch),
              child: SizedBox(
                width: 36,
                height: 36,
                child: AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, _) {
                    final pulse =
                        isSelected ? _pulseController.value : 0.0;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        if (isSelected)
                          Container(
                            width: 18 + (pulse * 16),
                            height: 18 + (pulse * 16),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: DriveOSColors.primaryBlue.withValues(
                                alpha: (1 - pulse) * 0.32,
                              ),
                            ),
                          ),
                        Container(
                          width: isSelected ? 18 : 14,
                          height: isSelected ? 18 : 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isSelected
                                ? DriveOSColors.primaryBlue
                                : const Color(0xFF0F172A),
                            border: Border.all(color: Colors.white, width: 2.5),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.25),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }),
        if (_showCard && _focusedBranch != null)
          Positioned(
            left: 16,
            right: 16,
            bottom: 18,
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: DriveOSColors.borderSlate),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0F172A).withValues(alpha: 0.14),
                        blurRadius: 18,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: DriveOSColors.primaryBlue
                                  .withValues(alpha: 0.10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              _focusedBranch!.code,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: DriveOSColors.primaryBlue,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              _focusedBranch!.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15.5,
                                fontWeight: FontWeight.w800,
                                color: DriveOSColors.graphiteText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _focusedBranch!.address,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: DriveOSColors.graphiteText
                              .withValues(alpha: 0.68),
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: DriveOSPrimaryPillButton(
                          icon: Icons.arrow_forward_rounded,
                          label: loc.translate('enter_branch'),
                          onPressed: () =>
                              widget.onEnterBranch(_focusedBranch!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
