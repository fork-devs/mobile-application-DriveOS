import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// A gradient pill button used for primary calls to action across DriveOS.
class DriveOSPrimaryPillButton extends StatelessWidget {
  /// Creates a [DriveOSPrimaryPillButton].
  const DriveOSPrimaryPillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
  });

  /// The button label text.
  final String label;

  /// Callback invoked when the button is tapped, or `null` when disabled.
  final VoidCallback? onPressed;

  /// Optional leading icon displayed next to [label].
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: enabled
            ? const LinearGradient(
                colors: [
                  DriveOSColors.primaryBlue,
                  DriveOSColors.accentSkyBlue,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        color: enabled ? null : DriveOSColors.borderSlate,
        borderRadius: BorderRadius.circular(14),
        boxShadow: enabled
            ? [
                BoxShadow(
                  color: DriveOSColors.primaryBlue.withValues(alpha: 0.25),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: enabled
              ? () {
                  HapticFeedback.lightImpact();
                  onPressed?.call();
                }
              : null,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 17, color: Colors.white),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
