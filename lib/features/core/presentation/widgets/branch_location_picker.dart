import 'package:flutter/material.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_primary_pill_button.dart';
import 'package:mobile_application_driveos/features/core/presentation/widgets/minimalist_map_config.dart';

/// Interactive vector map modal for selecting branch latitude and longitude
/// by tapping directly on the map.
class BranchLocationPicker extends StatefulWidget {
  /// Optional initial latitude to focus.
  final double? initialLatitude;

  /// Optional initial longitude to focus.
  final double? initialLongitude;

  /// Callback invoked when the user confirms a [LatLng] coordinate.
  final ValueChanged<LatLng> onLocationPicked;

  /// Creates a [BranchLocationPicker].
  const BranchLocationPicker({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
    required this.onLocationPicked,
  });

  @override
  State<BranchLocationPicker> createState() => _BranchLocationPickerState();
}

class _BranchLocationPickerState extends State<BranchLocationPicker> {
  MapLibreMapController? _mapController;
  Circle? _pickedCircle;
  LatLng? _pickedPoint;
  bool _styleLoaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialLatitude != null && widget.initialLongitude != null) {
      _pickedPoint = LatLng(widget.initialLatitude!, widget.initialLongitude!);
    }
  }

  Future<void> _syncCircle() async {
    final controller = _mapController;
    final point = _pickedPoint;
    if (controller == null || !_styleLoaded || point == null) return;

    final options = MinimalistMapConfig.pinCircleOptions(
      point,
      isSelected: true,
    );
    if (_pickedCircle == null) {
      _pickedCircle = await controller.addCircle(options);
    } else {
      await controller.updateCircle(_pickedCircle!, options);
    }
  }

  Future<void> _onMapTap(LatLng coordinates) async {
    setState(() => _pickedPoint = coordinates);
    await _syncCircle();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final initialTarget = _pickedPoint ?? MinimalistMapConfig.defaultCenter;

    return Scaffold(
      appBar: AppBar(
        title: Text(loc.translate('pick_location')),
      ),
      body: Stack(
        children: [
          MapLibreMap(
            styleString: MinimalistMapConfig.styleUrl,
            initialCameraPosition: CameraPosition(
              target: initialTarget,
              zoom: _pickedPoint != null ? 15.0 : 12.0,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onStyleLoadedCallback: () {
              _styleLoaded = true;
              _syncCircle();
            },
            onMapClick: (_, coordinates) => _onMapTap(coordinates),
          ),
          Positioned(
            top: 14,
            left: 16,
            right: 16,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: DriveOSColors.borderSlate),
                ),
                child: Text(
                  _pickedPoint == null
                      ? loc.translate('tap_map_to_place_pin')
                      : '${_pickedPoint!.latitude.toStringAsFixed(5)}, '
                          '${_pickedPoint!.longitude.toStringAsFixed(5)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: DriveOSColors.graphiteText,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: DriveOSPrimaryPillButton(
              icon: Icons.check_rounded,
              label: loc.translate('confirm_location'),
              onPressed: _pickedPoint == null
                  ? null
                  : () {
                      widget.onLocationPicked(_pickedPoint!);
                      Navigator.of(context).pop(_pickedPoint);
                    },
            ),
          ),
        ],
      ),
    );
  }
}
