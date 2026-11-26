import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A tactile wrapper that scales [child] down slightly while pressed and triggers
/// light haptic feedback on tap.
class DriveOSTactileCard extends StatefulWidget {
  /// Creates a [DriveOSTactileCard].
  const DriveOSTactileCard({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.985,
  });

  /// The widget rendered inside the tactile wrapper.
  final Widget child;

  /// Callback invoked when the user taps the card.
  final VoidCallback? onTap;

  /// The target scale applied while the pointer is pressed.
  final double pressedScale;

  @override
  State<DriveOSTactileCard> createState() => _DriveOSTactileCardState();
}

class _DriveOSTactileCardState extends State<DriveOSTactileCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: () {
        HapticFeedback.selectionClick();
        widget.onTap?.call();
      },
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}
