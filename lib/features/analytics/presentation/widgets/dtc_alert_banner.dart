import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Highlighted warning banner displaying active vehicle DTC telemetry alerts.
class DtcAlertBanner extends StatelessWidget {
  /// Number of active DTC alerts.
  final int alertCount;

  /// Optional callback invoked when the user taps the details action.
  final VoidCallback? onDetailsPressed;

  /// Creates a [DtcAlertBanner].
  const DtcAlertBanner({
    super.key,
    required this.alertCount,
    this.onDetailsPressed,
  });

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DriveOSColors.severityCrimson.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: DriveOSColors.severityCrimson.withValues(alpha: 0.32),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: DriveOSColors.severityCrimson.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: DriveOSColors.severityCrimson,
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${loc.translate('dtc_alerts_title')} ($alertCount)',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                    color: DriveOSColors.severityCrimson,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  loc.translate('dtc_alerts_subtitle'),
                  style: TextStyle(
                    fontSize: 12,
                    color: DriveOSColors.graphiteText.withValues(alpha: 0.72),
                  ),
                ),
              ],
            ),
          ),
          if (onDetailsPressed != null)
            TextButton(
              onPressed: onDetailsPressed,
              child: Text(loc.translate('view_details')),
            ),
        ],
      ),
    );
  }
}
