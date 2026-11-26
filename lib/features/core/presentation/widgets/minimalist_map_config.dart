import 'package:maplibre_gl/maplibre_gl.dart';

/// Shared MapLibre + OpenFreeMap configuration for DriveOS vector maps.
abstract final class MinimalistMapConfig {
  /// Bundled DriveOS-themed OpenFreeMap Positron vector style asset.
  static const String styleUrl = 'assets/map_styles/driveos_positron.json';

  /// Default camera center (Lima, Peru) when no geolocated branches exist yet.
  static const LatLng defaultCenter = LatLng(-12.0464, -77.0428);

  /// Builds consistent vector pin circle options matching DriveOSColors.
  static CircleOptions pinCircleOptions(
    LatLng point, {
    bool isSelected = false,
  }) {
    return CircleOptions(
      geometry: point,
      circleRadius: isSelected ? 9.0 : 6.5,
      circleColor: isSelected ? '#1E3A8A' : '#0F172A',
      circleStrokeColor: '#FFFFFF',
      circleStrokeWidth: 2.0,
      circleOpacity: 0.95,
    );
  }
}
