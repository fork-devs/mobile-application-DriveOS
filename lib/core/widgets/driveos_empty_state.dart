import 'package:flutter/material.dart';

/// A circular tinted icon badge used in empty-state views.
class DriveOSEmptyStateIcon extends StatelessWidget {
  /// Creates a [DriveOSEmptyStateIcon].
  const DriveOSEmptyStateIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size = 76,
    this.iconSize = 34,
  });

  /// The icon displayed at the center of the badge.
  final IconData icon;

  /// The accent color used for the icon and its translucent background.
  final Color color;

  /// The outer diameter of the circular badge.
  final double size;

  /// The size of [icon] inside the badge.
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: color),
    );
  }
}
