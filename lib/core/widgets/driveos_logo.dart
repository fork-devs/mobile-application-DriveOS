import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Size presets for [DriveOSLogo].
enum LogoSize {
  /// Compact header variant.
  small(44, 18, 12),

  /// Standard card/modal variant.
  medium(72, 26, 14),

  /// Large splash/hero variant.
  large(96, 32, 16);

  /// Width and height of the icon badge.
  final double boxSize;

  /// Font size of the wordmark title.
  final double titleSize;

  /// Font size of the optional subtitle.
  final double subtitleSize;

  const LogoSize(this.boxSize, this.titleSize, this.subtitleSize);
}

/// Official DriveOS Workshop branded logo with automotive engineering styling.
class DriveOSLogo extends StatelessWidget {
  /// The size preset of the logo.
  final LogoSize size;

  /// Whether to render the `DriveOS Workshop` wordmark below the icon badge.
  final bool showText;

  /// Whether the logo is placed on a dark background.
  final bool isDark;

  /// Creates a [DriveOSLogo].
  const DriveOSLogo({
    super.key,
    this.size = LogoSize.medium,
    this.showText = true,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconBox = Container(
      width: size.boxSize,
      height: size.boxSize,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            DriveOSColors.primaryBlue,
            Color(0xFF0F172A),
          ],
        ),
        borderRadius: BorderRadius.circular(size.boxSize * 0.25),
        border: Border.all(
          color: DriveOSColors.accentSkyBlue.withAlpha(120),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: DriveOSColors.accentSkyBlue.withAlpha(50),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withAlpha(40),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            right: 4,
            bottom: 4,
            child: Icon(
              Icons.sensors,
              size: size.boxSize * 0.35,
              color: DriveOSColors.accentSkyBlue.withAlpha(60),
            ),
          ),
          Icon(
            Icons.car_repair,
            color: Colors.white,
            size: size.boxSize * 0.55,
          ),
        ],
      ),
    );

    if (!showText) return iconBox;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        iconBox,
        const SizedBox(height: 14),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
              fontSize: size.titleSize,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : DriveOSColors.primaryBlue,
              letterSpacing: -0.5,
            ),
            children: [
              const TextSpan(text: 'Drive'),
              const TextSpan(
                text: 'OS',
                style: TextStyle(
                  color: DriveOSColors.accentSkyBlue,
                  fontWeight: FontWeight.w900,
                ),
              ),
              TextSpan(
                text: ' Workshop',
                style: TextStyle(
                  fontSize: size.titleSize * 0.82,
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : DriveOSColors.graphiteText,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
