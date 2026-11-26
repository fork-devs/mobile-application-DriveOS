import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Unified dark-navy DriveOS gradient header shared across role-scoped screens.
class DriveOSPageHeader extends StatelessWidget {
  /// Primary title displayed in the header.
  final String title;

  /// Optional secondary subtitle displayed below [title].
  final String? subtitle;

  /// Optional pill badge displayed above [title].
  final String? badgeLabel;

  /// Whether to render a leading back button.
  final bool showBackButton;

  /// Custom callback invoked when the back button is tapped.
  final VoidCallback? onBackPressed;

  /// Trailing action widgets displayed on the right side of the header.
  final List<Widget> actions;

  /// Creates a [DriveOSPageHeader].
  const DriveOSPageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeLabel,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0F172A), DriveOSColors.primaryBlue],
        ),
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(24),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
          child: Row(
            children: [
              if (showBackButton) ...[
                IconButton(
                  onPressed: onBackPressed ?? () => Navigator.of(context).pop(),
                  tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                  padding: const EdgeInsets.all(6),
                  constraints: const BoxConstraints(
                    minWidth: 34,
                    minHeight: 34,
                  ),
                  splashRadius: 20,
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (badgeLabel != null && badgeLabel!.isNotEmpty) ...[
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withAlpha(22),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withAlpha(45),
                          ),
                        ),
                        child: Text(
                          badgeLabel!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                    ],
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        title,
                        maxLines: 1,
                        style: const TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12.5,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (actions.isNotEmpty) ...[
                const SizedBox(width: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (var i = 0; i < actions.length; i++) ...[
                      if (i > 0) const SizedBox(width: 8),
                      actions[i],
                    ],
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Layout wrapper that smoothly collapses [header] when scrolling down and
/// reveals it when scrolling up, maximizing vertical space across screens.
class DriveOSCollapsibleHeaderBody extends StatefulWidget {
  /// The collapsible top header widget (typically [DriveOSPageHeader]).
  final Widget header;

  /// The scrollable body content rendered below [header].
  final Widget body;

  /// Creates a [DriveOSCollapsibleHeaderBody].
  const DriveOSCollapsibleHeaderBody({
    super.key,
    required this.header,
    required this.body,
  });

  @override
  State<DriveOSCollapsibleHeaderBody> createState() =>
      _DriveOSCollapsibleHeaderBodyState();
}

class _DriveOSCollapsibleHeaderBodyState
    extends State<DriveOSCollapsibleHeaderBody> {
  final ValueNotifier<bool> _headerVisibleNotifier = ValueNotifier<bool>(true);
  double _accumulatedDelta = 0;

  @override
  void dispose() {
    _headerVisibleNotifier.dispose();
    super.dispose();
  }

  bool _handleScrollNotification(ScrollUpdateNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final metrics = notification.metrics;
    final delta = notification.scrollDelta ?? 0;
    if (delta == 0) return false;

    if (metrics.pixels <= 16) {
      if (!_headerVisibleNotifier.value) {
        _headerVisibleNotifier.value = true;
      }
      _accumulatedDelta = 0;
      return false;
    }

    if (metrics.pixels >= metrics.maxScrollExtent) {
      return false;
    }

    if ((delta > 0 && _accumulatedDelta < 0) ||
        (delta < 0 && _accumulatedDelta > 0)) {
      _accumulatedDelta = 0;
    }
    _accumulatedDelta += delta;

    if (_accumulatedDelta > 18 && _headerVisibleNotifier.value) {
      _headerVisibleNotifier.value = false;
      _accumulatedDelta = 0;
    } else if (_accumulatedDelta < -12 && !_headerVisibleNotifier.value) {
      _headerVisibleNotifier.value = true;
      _accumulatedDelta = 0;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: _headerVisibleNotifier,
          builder: (context, visible, child) {
            return ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                heightFactor: visible ? 1.0 : 0.0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  opacity: visible ? 1.0 : 0.0,
                  child: child,
                ),
              ),
            );
          },
          child: widget.header,
        ),
        Expanded(
          child: ValueListenableBuilder<bool>(
            valueListenable: _headerVisibleNotifier,
            builder: (context, visible, child) {
              return SafeArea(
                top: !visible,
                bottom: false,
                child: child!,
              );
            },
            child: NotificationListener<ScrollUpdateNotification>(
              onNotification: _handleScrollNotification,
              child: widget.body,
            ),
          ),
        ),
      ],
    );
  }
}
