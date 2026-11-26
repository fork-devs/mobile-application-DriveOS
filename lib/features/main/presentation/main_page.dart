import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_application_driveos/core/auth/mobile_role_scope.dart';
import 'package:mobile_application_driveos/core/di/dependency_injection.dart';
import 'package:mobile_application_driveos/core/localization/app_localizations.dart';
import 'package:mobile_application_driveos/core/storage/session_storage.dart';
import 'package:mobile_application_driveos/core/theme/app_theme.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_empty_state.dart';
import 'package:mobile_application_driveos/core/widgets/driveos_floating_nav_bar.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/views/dashboard_page.dart';
import 'package:mobile_application_driveos/features/analytics/presentation/views/employee_dashboard_page.dart';
import 'package:mobile_application_driveos/features/auth/application/auth_application.dart';
import 'package:mobile_application_driveos/features/customer/presentation/views/customer_home_page.dart';
import 'package:mobile_application_driveos/features/operations/presentation/views/work_orders_page.dart';

class _NavDestinationSpec {
  final Key key;
  final IconData icon;
  final IconData selectedIcon;
  final String labelKey;
  final Widget page;

  const _NavDestinationSpec({
    required this.key,
    required this.icon,
    required this.selectedIcon,
    required this.labelKey,
    required this.page,
  });
}

/// Role-scoped main navigation shell for `WORKSHOP_ADMIN` and `TECHNICIAN`
/// accounts, delegating `CUSTOMER` accounts to [CustomerHomePage].
class MainPage extends StatefulWidget {
  /// Initial selected tab index.
  final int initialIndex;

  /// Optional explicit role scope override (used in tests).
  final MobileRoleScope? roleScope;

  /// Optional tab page overrides (used in tests or incremental integration).
  final List<Widget>? overridePages;

  /// Creates a [MainPage].
  const MainPage({
    super.key,
    this.initialIndex = 0,
    this.roleScope,
    this.overridePages,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  late int _currentIndex;
  int _transitionDirection = 1;
  late final AnimationController _tabController;
  late final Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  MobileRoleScope? _cachedScope;
  late List<_NavDestinationSpec> _cachedSpecs;

  MobileRoleScope get _effectiveScope {
    if (widget.roleScope != null) return widget.roleScope!;
    if (getIt.isRegistered<SessionStorage>()) {
      return RoleRouter.resolveScopeOrNull(getIt<SessionStorage>().roles) ??
          MobileRoleScope.technician;
    }
    return MobileRoleScope.technician;
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _tabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
      value: 1.0,
    );
    _fadeAnimation = Tween<double>(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _tabController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _tabController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onDestinationSelected(int index) {
    if (index == _currentIndex) return;
    final direction = index > _currentIndex ? 1 : -1;
    setState(() {
      _transitionDirection = direction;
      _currentIndex = index;
      _slideAnimation = Tween<Offset>(
        begin: Offset(0.025 * _transitionDirection, 0),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(parent: _tabController, curve: Curves.easeOutCubic),
      );
    });
    _tabController.forward(from: 0.0);
  }

  Future<void> _signOut() async {
    if (getIt.isRegistered<Logout>()) {
      await getIt<Logout>()();
    } else if (getIt.isRegistered<SessionStorage>()) {
      await getIt<SessionStorage>().clearSession();
    }
    if (mounted) {
      context.go('/login');
    }
  }

  List<_NavDestinationSpec> _buildDestinations(MobileRoleScope scope) {
    final override = widget.overridePages;
    if (scope == MobileRoleScope.workshopAdmin) {
      return [
        _NavDestinationSpec(
          key: const Key('nav_dashboard'),
          icon: Icons.space_dashboard_outlined,
          selectedIcon: Icons.space_dashboard_rounded,
          labelKey: 'dashboard_tab',
          page: override != null && override.isNotEmpty
              ? override[0]
              : DashboardPage(
                  onNavigateToOrders: () => _onDestinationSelected(1),
                  onNavigateToAppointments: () => _onDestinationSelected(2),
                  onNavigateToInventory: () => _onDestinationSelected(3),
                  onNavigateToIot: () => _onDestinationSelected(4),
                ),
        ),
        _NavDestinationSpec(
          key: const Key('nav_orders'),
          icon: Icons.build_outlined,
          selectedIcon: Icons.build_rounded,
          labelKey: 'orders_tab',
          page: override != null && override.length > 1
              ? override[1]
              : const WorkOrdersPage(),
        ),
        _NavDestinationSpec(
          key: const Key('nav_appointments'),
          icon: Icons.calendar_month_outlined,
          selectedIcon: Icons.calendar_month_rounded,
          labelKey: 'appointments_tab',
          page: override != null && override.length > 2
              ? override[2]
              : _ShellTabScaffold(
                  titleKey: 'appointments_tab',
                  icon: Icons.calendar_month_outlined,
                  onSwitchBranch: () => context.go('/branches'),
                  onSignOut: _signOut,
                ),
        ),
        _NavDestinationSpec(
          key: const Key('nav_inventory'),
          icon: Icons.inventory_2_outlined,
          selectedIcon: Icons.inventory_2_rounded,
          labelKey: 'inventory_tab',
          page: override != null && override.length > 3
              ? override[3]
              : _ShellTabScaffold(
                  titleKey: 'inventory_tab',
                  icon: Icons.inventory_2_outlined,
                  onSwitchBranch: () => context.go('/branches'),
                  onSignOut: _signOut,
                ),
        ),
        _NavDestinationSpec(
          key: const Key('nav_telemetry'),
          icon: Icons.sensors_outlined,
          selectedIcon: Icons.sensors_rounded,
          labelKey: 'telemetry_tab',
          page: override != null && override.length > 4
              ? override[4]
              : _ShellTabScaffold(
                  titleKey: 'telemetry_tab',
                  icon: Icons.sensors_outlined,
                  onSwitchBranch: () => context.go('/branches'),
                  onSignOut: _signOut,
                ),
        ),
      ];
    }

    return [
      _NavDestinationSpec(
        key: const Key('nav_dashboard'),
        icon: Icons.space_dashboard_outlined,
        selectedIcon: Icons.space_dashboard_rounded,
        labelKey: 'dashboard_tab',
        page: override != null && override.isNotEmpty
            ? override[0]
            : EmployeeDashboardPage(
                onNavigateToOrders: () => _onDestinationSelected(1),
                onNavigateToTelemetry: () => _onDestinationSelected(2),
              ),
      ),
      _NavDestinationSpec(
        key: const Key('nav_orders'),
        icon: Icons.build_outlined,
        selectedIcon: Icons.build_rounded,
        labelKey: 'orders_tab',
        page: override != null && override.length > 1
            ? override[1]
            : _ShellTabScaffold(
                titleKey: 'orders_tab',
                icon: Icons.build_outlined,
                onSwitchBranch: () => context.go('/branches'),
                onSignOut: _signOut,
              ),
      ),
      _NavDestinationSpec(
        key: const Key('nav_telemetry'),
        icon: Icons.sensors_outlined,
        selectedIcon: Icons.sensors_rounded,
        labelKey: 'telemetry_tab',
        page: override != null && override.length > 2
            ? override[2]
            : _ShellTabScaffold(
                titleKey: 'telemetry_tab',
                icon: Icons.sensors_outlined,
                onSwitchBranch: () => context.go('/branches'),
                onSignOut: _signOut,
              ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final scope = _effectiveScope;
    if (scope == MobileRoleScope.customer) {
      return const CustomerHomePage();
    }

    final loc = AppLocalizations.of(context);
    if (_cachedScope != scope) {
      _cachedScope = scope;
      _cachedSpecs = _buildDestinations(scope);
    }
    final specs = _cachedSpecs;
    final safeIndex = _currentIndex.clamp(0, specs.length - 1);

    return Scaffold(
      extendBody: true,
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: IndexedStack(
            index: safeIndex,
            children: specs.map((spec) => spec.page).toList(),
          ),
        ),
      ),
      bottomNavigationBar: DriveOSFloatingNavBar(
        key: const Key('main_navigation_bar'),
        selectedIndex: safeIndex,
        onDestinationSelected: _onDestinationSelected,
        items: specs
            .map(
              (spec) => DriveOSNavItem(
                key: spec.key,
                icon: spec.icon,
                selectedIcon: spec.selectedIcon,
                label: loc.translate(spec.labelKey),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _ShellTabScaffold extends StatelessWidget {
  const _ShellTabScaffold({
    required this.titleKey,
    required this.icon,
    required this.onSwitchBranch,
    required this.onSignOut,
  });

  final String titleKey;
  final IconData icon;
  final VoidCallback onSwitchBranch;
  final VoidCallback onSignOut;

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context);
    final activeBranch = getIt.isRegistered<SessionStorage>()
        ? getIt<SessionStorage>().activeBranchName
        : null;

    return Scaffold(
      backgroundColor: DriveOSColors.warmNeutral,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.translate(titleKey)),
            if (activeBranch != null && activeBranch.isNotEmpty)
              Text(
                activeBranch,
                style: TextStyle(
                  fontSize: 12,
                  color: DriveOSColors.graphiteText.withValues(alpha: 0.65),
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: loc.translate('switch_branch'),
            icon: const Icon(Icons.storefront_outlined),
            onPressed: onSwitchBranch,
          ),
          IconButton(
            tooltip: loc.translate('sign_out'),
            icon: const Icon(Icons.logout_rounded),
            onPressed: onSignOut,
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DriveOSEmptyStateIcon(
              icon: icon,
              color: DriveOSColors.primaryBlue,
            ),
            const SizedBox(height: 14),
            Text(
              loc.translate(titleKey),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: DriveOSColors.graphiteText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
