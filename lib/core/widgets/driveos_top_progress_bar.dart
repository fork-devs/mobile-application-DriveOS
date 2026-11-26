import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Non-blocking top gradient sweep bar shown during background fetches.
class DriveOSTopProgressBar extends StatefulWidget {
  /// Whether the progress sweep animation is active.
  final bool isLoading;

  /// The vertical height of the progress bar.
  final double height;

  /// Creates a [DriveOSTopProgressBar].
  const DriveOSTopProgressBar({
    super.key,
    required this.isLoading,
    this.height = 2.5,
  });

  @override
  State<DriveOSTopProgressBar> createState() => _DriveOSTopProgressBarState();
}

class _DriveOSTopProgressBarState extends State<DriveOSTopProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant DriveOSTopProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: widget.isLoading ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      child: SizedBox(
        height: widget.height,
        width: double.infinity,
        child: ClipRect(
          child: ColoredBox(
            color: DriveOSColors.primaryBlue.withValues(alpha: 0.10),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _TopSweepPainter(progress: _controller.value),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _TopSweepPainter extends CustomPainter {
  final double progress;

  const _TopSweepPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final barWidth = size.width * 0.42;
    final startX = -barWidth + (size.width + barWidth) * progress;
    final rect = Rect.fromLTWH(startX, 0, barWidth, size.height);

    final paint = Paint()
      ..shader = const LinearGradient(
        colors: [
          Colors.transparent,
          DriveOSColors.accentSkyBlue,
          DriveOSColors.primaryBlue,
          Colors.transparent,
        ],
        stops: [0.0, 0.35, 0.7, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _TopSweepPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
