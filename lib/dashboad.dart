import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/project_pages.dart';
import 'package:flutter_portfolio/widgets.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_theme.dart';
import 'firebase_services.dart';
import 'login_screen.dart';
import 'message_pages.dart';
import 'overview_pages.dart';


class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;

  final _pages = const [
    OverviewPage(),
    ProjectsPage(),
    MessagesPage(),
  ];

  final _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Overview'),
    _NavItem(icon: Icons.phone_android_rounded, label: 'Projects'),
    _NavItem(icon: Icons.mail_rounded, label: 'Messages'),
  ];

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          // Sidebar (desktop/tablet)
          if (!isMobile)
            _Sidebar(
              items: _navItems,
              selectedIndex: _selectedIndex,
              collapsed: _sidebarCollapsed,
              onSelect: (i) => setState(() => _selectedIndex = i),
              onToggle: () =>
                  setState(() => _sidebarCollapsed = !_sidebarCollapsed),
            ),

          // Main content
          Expanded(
            child: Column(
              children: [
                // Top bar
                _TopBar(
                  title: _navItems[_selectedIndex].label,
                  isMobile: isMobile,
                  onMenuTap: isMobile
                      ? () => Scaffold.of(context).openDrawer()
                      : null,
                ),
                // Page content
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _pages[_selectedIndex],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: AppColors.surface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GradientText(
                '< YN />',
                style: GoogleFonts.jetBrainsMono(
                    fontSize: 22, fontWeight: FontWeight.w800),
                gradient: AppColors.accentGradient,
              ),
            ),
            const Divider(color: AppColors.border),
            ..._navItems.asMap().entries.map((e) => ListTile(
              leading: Icon(e.value.icon,
                  color: e.key == _selectedIndex
                      ? AppColors.cyan
                      : AppColors.textSecondary),
              title: Text(
                e.value.label,
                style: GoogleFonts.spaceGrotesk(
                  color: e.key == _selectedIndex
                      ? AppColors.cyan
                      : AppColors.textPrimary,
                  fontWeight: e.key == _selectedIndex
                      ? FontWeight.w700
                      : FontWeight.w500,
                ),
              ),
              selected: e.key == _selectedIndex,
              selectedTileColor: AppColors.cyanDim,
              onTap: () {
                setState(() => _selectedIndex = e.key);
                Navigator.pop(context);
              },
            )),
            const Spacer(),
            const Divider(color: AppColors.border),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: Text('Sign Out',
                  style: GoogleFonts.spaceGrotesk(color: Colors.redAccent)),
              onTap: _signOut,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseService().signOut();
    Get.off(() => const LoginScreen());
  }
}

// ──────────────────────────────────────────────
// SIDEBAR
// ──────────────────────────────────────────────
class _Sidebar extends StatelessWidget {
  final List<_NavItem> items;
  final int selectedIndex;
  final bool collapsed;
  final Function(int) onSelect;
  final VoidCallback onToggle;

  const _Sidebar({
    required this.items,
    required this.selectedIndex,
    required this.collapsed,
    required this.onSelect,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final width = collapsed ? 72.0 : 240.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      width: width,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(right: BorderSide(color: AppColors.border)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Logo
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: collapsed ? 0 : 1,
            child: collapsed
                ? const SizedBox(height: 32)
                : GradientText(
              '< YN />',
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 18, fontWeight: FontWeight.w800),
              gradient: AppColors.accentGradient,
            ),
          ),
          const SizedBox(height: 32),

          // Nav Items
          ...items.asMap().entries.map((e) => _SidebarItem(
            item: e.value,
            isSelected: e.key == selectedIndex,
            collapsed: collapsed,
            onTap: () => onSelect(e.key),
          )),

          const Spacer(),

          // Sign Out
          _SidebarItem(
            item: _NavItem(
                icon: Icons.logout_rounded, label: 'Sign Out'),
            isSelected: false,
            collapsed: collapsed,
            onTap: () async {
              await FirebaseService().signOut();
              Get.off(() => const LoginScreen());
            },
            isDestructive: true,
          ),

          // Collapse toggle
          Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: onToggle,
              icon: Icon(
                collapsed
                    ? Icons.keyboard_double_arrow_right_rounded
                    : Icons.keyboard_double_arrow_left_rounded,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

class _SidebarItem extends StatelessWidget {
  final _NavItem item;
  final bool isSelected;
  final bool collapsed;
  final VoidCallback onTap;
  final bool isDestructive;

  const _SidebarItem({
    required this.item,
    required this.isSelected,
    required this.collapsed,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive
        ? Colors.redAccent
        : isSelected
        ? AppColors.cyan
        : AppColors.textSecondary;

    return Tooltip(
      message: collapsed ? item.label : '',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          padding: EdgeInsets.symmetric(
              horizontal: collapsed ? 0 : 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.cyanDim : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: collapsed
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(item.icon, color: color, size: 20),
              if (!collapsed) ...[
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    item.label,
                    style: GoogleFonts.spaceGrotesk(
                      color: color,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                      fontSize: 14,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// TOP BAR
// ──────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  final String title;
  final bool isMobile;
  final VoidCallback? onMenuTap;

  const _TopBar(
      {required this.title, required this.isMobile, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          if (isMobile && onMenuTap != null)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded,
                  color: AppColors.textPrimary),
            ),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          // Admin badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cyanDim,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings_rounded,
                    size: 14, color: AppColors.cyan),
                const SizedBox(width: 6),
                Text(
                  'Admin',
                  style: GoogleFonts.spaceGrotesk(
                    color: AppColors.cyan,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  _NavItem({required this.icon, required this.label});
}