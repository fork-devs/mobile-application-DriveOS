import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Descriptor for a single destination in [DriveOSFloatingNavBar].
class DriveOSNavItem {
  /// Unique widget key for testing and accessibility.
  final Key key;

  /// Icon displayed when the destination is unselected.
  final IconData icon;

  /// Icon displayed when the destination is selected.
  final IconData selectedIcon;

  /// Localized destination label shown beneath the active icon.
  final String label;

  /// Creates a [DriveOSNavItem].
  const DriveOSNavItem({
    required this.key,
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

/// Floating Dark Navy navigation dock with a gliding primary-blue active pill,
/// icon scale reactivity, and haptic feedback.
class DriveOSFloatingNavBar extends StatelessWidget {
  /// Destinations rendered across the dock.
  final List<DriveOSNavItem> items;

  /// Zero-based index of the currently selected destination.
  final int selectedIndex;

  /// Callback invoked when the user taps a destination.
  final ValueChanged<int> onDestinationSelected;

  /// Creates a [DriveOSFloatingNavBar].
  const DriveOSFloatingNavBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final safeIndex = selectedIndex.clamp(0, items.length - 1);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: RepaintBoundary(
          child: Container(
            height: 64,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF172554),
                ],
              ),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(
                color: Colors.white.withAlpha(36),
                width: 1,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x380F172A),
                  blurRadius: 24,
                  offset: Offset(0, 10),
                ),
                BoxShadow(
                  color: Color(0x222563EB),
                  blurRadius: 12,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final slotWidth = constraints.maxWidth / items.length;
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 280),
                      curve: Curves.easeOutCubic,
                      left: safeIndex * slotWidth,
                      top: 0,
                      bottom: 0,
                      width: slotWidth,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0x5260A5FA),
                              Color(0x2E2563EB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: Colors.white.withAlpha(115),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < items.length; i++)
                          Expanded(
                            child: _FloatingNavSlot(
                              item: items[i],
                              selected: i == safeIndex,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onDestinationSelected(i);
                              },
                            ),
                          ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _FloatingNavSlot extends StatefulWidget {
  const _FloatingNavSlot({
    required this.item,
    required this.selected,
    required this.onTap,
  });

  final DriveOSNavItem item;
  final bool selected;
  final VoidCallback onTap;

  @override
  State<_FloatingNavSlot> createState() => _FloatingNavSlotState();
}

class _FloatingNavSlotState extends State<_FloatingNavSlot> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final color = selected ? Colors.white : const Color(0xFF94A3B8);

    return GestureDetector(
      key: widget.item.key,
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 140),
        curve: Curves.easeOutCubic,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedScale(
              scale: selected ? 1.12 : 1.0,
              duration: const Duration(milliseconds: 240),
              curve: Curves.easeOutBack,
              child: Icon(
                selected ? widget.item.selectedIcon : widget.item.icon,
                size: 21,
                color: color,
              ),
            ),
            ClipRect(
              child: AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment: Alignment.topCenter,
                heightFactor: selected ? 1.0 : 0.0,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 180),
                  curve: Curves.easeOut,
                  opacity: selected ? 1.0 : 0.0,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2, left: 4, right: 4),
                    child: Text(
                      widget.item.label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: -0.1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
