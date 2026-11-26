import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Visual severity variants supported by [DriveOSToast].
enum DriveOSToastType {
  /// Indicates a completed action or positive outcome.
  success,

  /// Indicates a failed operation or validation error.
  error,

  /// Indicates a non-blocking warning or caution.
  warning,

  /// Indicates neutral informational feedback.
  info,
}

/// A top-floating overlay toast that slides in, auto-dismisses, and supports
/// swipe-up or tap dismissal.
class DriveOSToast {
  DriveOSToast._();

  static OverlayEntry? _currentEntry;

  /// Displays a floating toast with [message] and styling for [type].
  static void show(
    BuildContext context,
    String message, {
    DriveOSToastType type = DriveOSToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;

    _currentEntry?.remove();
    _currentEntry = null;

    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => _ToastOverlay(
        message: message,
        type: type,
        duration: duration,
        onDismissed: () {
          if (_currentEntry == entry) {
            _currentEntry = null;
          }
          entry.remove();
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _ToastOverlay extends StatefulWidget {
  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismissed,
  });

  final String message;
  final DriveOSToastType type;
  final Duration duration;
  final VoidCallback onDismissed;

  @override
  State<_ToastOverlay> createState() => _ToastOverlayState();
}

class _ToastOverlayState extends State<_ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  Timer? _dismissTimer;
  bool _isDismissing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _slide = Tween<Offset>(
      begin: const Offset(0, -1.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
        reverseCurve: Curves.easeInCubic,
      ),
    );
    _fade = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _controller.forward();
    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  Future<void> _dismiss() async {
    if (_isDismissing || !mounted) return;
    _isDismissing = true;
    _dismissTimer?.cancel();
    await _controller.reverse();
    if (mounted) {
      widget.onDismissed();
    }
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final (Color accent, IconData icon) = switch (widget.type) {
      DriveOSToastType.success => (
          DriveOSColors.preventiveGreen,
          Icons.check_rounded,
        ),
      DriveOSToastType.error => (
          DriveOSColors.severityCrimson,
          Icons.error_outline_rounded,
        ),
      DriveOSToastType.warning => (
          DriveOSColors.severityOrange,
          Icons.warning_amber_rounded,
        ),
      DriveOSToastType.info => (
          DriveOSColors.primaryBlue,
          Icons.info_outline_rounded,
        ),
    };

    return Positioned(
      top: MediaQuery.of(context).padding.top + 10,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: SlideTransition(
          position: _slide,
          child: FadeTransition(
            opacity: _fade,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (_) {
                _dismissTimer?.cancel();
                widget.onDismissed();
              },
              child: Center(
                child: GestureDetector(
                  onTap: _dismiss,
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 420),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: DriveOSColors.borderSlate),
                      boxShadow: [
                        BoxShadow(
                          color:
                              const Color(0xFF0F172A).withValues(alpha: 0.12),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 26,
                          height: 26,
                          decoration: BoxDecoration(
                            color: accent.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(icon, size: 15, color: accent),
                        ),
                        const SizedBox(width: 10),
                        Flexible(
                          child: Text(
                            widget.message,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: DriveOSColors.graphiteText,
                            ),
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
      ),
    );
  }
}
