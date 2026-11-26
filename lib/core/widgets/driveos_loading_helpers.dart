import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_top_progress_bar.dart';

/// Smooth 220ms fade-and-slide transition when asynchronous content arrives.
class DriveOSContentTransition extends StatelessWidget {
  /// The child widget to animate between states.
  final Widget child;

  /// The transition duration.
  final Duration duration;

  /// Creates a [DriveOSContentTransition].
  const DriveOSContentTransition({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 220),
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) {
        final slide = Tween<Offset>(
          begin: const Offset(0, 0.025),
          end: Offset.zero,
        ).animate(animation);
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(position: slide, child: child),
        );
      },
      child: child,
    );
  }
}

/// Spinner-free inline action label with an animated horizontal sweep bar.
class DriveOSInlineProgress extends StatelessWidget {
  /// The action label displayed above the sweep bar.
  final String label;

  /// Text color of [label].
  final Color textColor;

  /// Font size of [label].
  final double fontSize;

  /// Creates a [DriveOSInlineProgress].
  const DriveOSInlineProgress({
    super.key,
    required this.label,
    this.textColor = Colors.white,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        const SizedBox(
          width: 72,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(4)),
            child: DriveOSTopProgressBar(isLoading: true, height: 2.5),
          ),
        ),
      ],
    );
  }
}
