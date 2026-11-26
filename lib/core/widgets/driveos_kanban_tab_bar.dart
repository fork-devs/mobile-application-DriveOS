import 'package:flutter/material.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';

/// Descriptor for a single Kanban status tab with an optional live item count.
class DriveOSKanbanTabItem {
  /// Tab display label.
  final String label;

  /// Optional count badge shown when greater than zero.
  final int count;

  /// Creates a [DriveOSKanbanTabItem].
  const DriveOSKanbanTabItem({
    required this.label,
    this.count = 0,
  });
}

/// Minimalist underline tab bar shared across DriveOS Kanban-style list
/// screens.
class DriveOSKanbanTabBar extends StatelessWidget {
  /// Controller synchronizing tab selection with page state.
  final TabController controller;

  /// Ordered list of tab items to display.
  final List<DriveOSKanbanTabItem> tabs;

  /// Creates a [DriveOSKanbanTabBar].
  const DriveOSKanbanTabBar({
    super.key,
    required this.controller,
    required this.tabs,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      child: TabBar(
        controller: controller,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        labelPadding: const EdgeInsets.symmetric(horizontal: 14),
        indicatorColor: DriveOSColors.primaryBlue,
        indicatorWeight: 2.5,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: DriveOSColors.borderSlate.withValues(alpha: 0.6),
        labelColor: DriveOSColors.primaryBlue,
        unselectedLabelColor: const Color(0xFF64748B),
        labelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 13.5,
          fontWeight: FontWeight.w600,
        ),
        tabs: tabs
            .map(
              (item) => Tab(
                height: 44,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(item.label),
                    if (item.count > 0) ...[
                      const SizedBox(width: 6),
                      Text(
                        '${item.count}',
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
