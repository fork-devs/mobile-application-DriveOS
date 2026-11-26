import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Translucent Liquid Glass pill/rectangular button with DriveOS ice-blue
/// glass tint, crisp border, and high-contrast primary-blue text.
class DriveOSLiquidButton extends StatelessWidget {
  /// Optional text label displayed beside [icon].
  final String? label;

  /// Optional leading icon displayed inside the button.
  final IconData? icon;

  /// Callback invoked when the button is tapped.
  final VoidCallback onPressed;

  /// Button height in logical pixels.
  final double height;

  /// Corner radius in logical pixels.
  final double borderRadius;

  /// Internal content padding.
  final EdgeInsetsGeometry padding;

  /// Whether the button should expand horizontally to fill available width.
  final bool expand;

  /// Creates a [DriveOSLiquidButton].
  const DriveOSLiquidButton({
    super.key,
    this.label,
    this.icon,
    required this.onPressed,
    this.height = 44,
    this.borderRadius = 14,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
    this.expand = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    return RepaintBoundary(
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          boxShadow: [
            BoxShadow(
              color: DriveOSColors.primaryBlue.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: radius,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onPressed,
                borderRadius: radius,
                child: Container(
                  width: expand ? double.infinity : null,
                  height: height,
                  padding: padding,
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        DriveOSColors.primaryBlue.withValues(alpha: 0.09),
                        DriveOSColors.accentSkyBlue.withValues(alpha: 0.20),
                      ],
                    ),
                    border: Border.all(
                      color: DriveOSColors.primaryBlue.withValues(alpha: 0.28),
                      width: 1.2,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (icon != null) ...[
                        Icon(icon, size: 18, color: DriveOSColors.primaryBlue),
                        if (label != null) const SizedBox(width: 8),
                      ],
                      if (label != null)
                        Text(
                          label!,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: DriveOSColors.primaryBlue,
                            letterSpacing: 0.1,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
