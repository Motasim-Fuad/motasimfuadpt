import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/controllers/auth_controller.dart';
import 'package:flutter_portfolio/controllers/contact_controller.dart';
import 'package:flutter_portfolio/controllers/skill_controller.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:flutter_portfolio/views/dashboard/blogs_page.dart';
import 'package:flutter_portfolio/views/dashboard/messages_page.dart';
import 'package:flutter_portfolio/views/dashboard/overview_page.dart';
import 'package:flutter_portfolio/views/dashboard/projects_page.dart';
import 'package:flutter_portfolio/views/dashboard/skills_page.dart';
import 'package:flutter_portfolio/views/dashboard/stats_page.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  bool _sidebarCollapsed = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _pages = const [
    OverviewPage(),
    ProjectsPage(),
    SkillsPage(),
    BlogsPage(),
    StatsPage(),
    MessagesPage(),
  ];

  final _navItems = [
    _NavItem(icon: Icons.dashboard_rounded, label: 'Overview'),
    _NavItem(icon: Icons.phone_android_rounded, label: 'Projects'),
    _NavItem(icon: Icons.code_rounded, label: 'Skills'),
    _NavItem(icon: Icons.article_rounded, label: 'Blogs'),
    _NavItem(icon: Icons.bar_chart_rounded, label: 'Stats'),
    _NavItem(icon: Icons.mail_rounded, label: 'Messages'),
  ];

  @override
  void initState() {
    super.initState();
    ContactController.to.initAdminStream();
    SkillController.to.cleanupDuplicatesOnce();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.dashBg,
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isMobile)
            _Sidebar(
              items: _navItems,
              selectedIndex: _selectedIndex,
              collapsed: _sidebarCollapsed,
              onSelect: (i) => setState(() => _selectedIndex = i),
              onToggle: () => setState(() => _sidebarCollapsed = !_sidebarCollapsed),
            ),
          Expanded(
            child: Column(
              children: [
                _TopBar(
                  title: _navItems[_selectedIndex].label,
                  isMobile: isMobile,
                  onMenuTap: isMobile
                      ? () => _scaffoldKey.currentState?.openDrawer()
                      : null,
                ),
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
      backgroundColor: AppColors.dashSurface,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: GradientText(
                'Motasim Fuad',
                style: GoogleFonts.spaceGrotesk(fontSize: 18, fontWeight: FontWeight.w800),
                gradient: AppColors.accentGradient,
              ),
            ),
            const Divider(color: AppColors.dashBorder),
            ..._navItems.asMap().entries.map((e) => ListTile(
              leading: Icon(e.value.icon,
                  color: e.key == _selectedIndex ? AppColors.cyan : AppColors.dashMuted),
              title: Text(
                e.value.label,
                style: GoogleFonts.spaceGrotesk(
                  color: e.key == _selectedIndex ? AppColors.cyan : AppColors.dashText,
                  fontWeight: e.key == _selectedIndex ? FontWeight.w700 : FontWeight.w500,
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
            const Divider(color: AppColors.dashBorder),
            ListTile(
              leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
              title: Text('Sign Out', style: GoogleFonts.spaceGrotesk(color: Colors.redAccent)),
              onTap: () => AuthController.to.signOut(),
            ),
          ],
        ),
      ),
    );
  }
}

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
        color: AppColors.dashSurface,
        border: Border(right: BorderSide(color: AppColors.dashBorder)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 24),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: collapsed ? 0 : 1,
            child: collapsed
                ? const SizedBox(height: 32)
                : GradientText(
              'Motasim Fuad',
              style: GoogleFonts.spaceGrotesk(fontSize: 14, fontWeight: FontWeight.w800),
              gradient: AppColors.accentGradient,
            ),
          ),
          const SizedBox(height: 32),
          ...items.asMap().entries.map((e) => _SidebarItem(
            item: e.value,
            isSelected: e.key == selectedIndex,
            collapsed: collapsed,
            onTap: () => onSelect(e.key),
          )),
          const Spacer(),
          _SidebarItem(
            item: _NavItem(icon: Icons.logout_rounded, label: 'Sign Out'),
            isSelected: false,
            collapsed: collapsed,
            onTap: () => AuthController.to.signOut(),
            isDestructive: true,
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: IconButton(
              onPressed: onToggle,
              icon: Icon(
                collapsed ? Icons.keyboard_double_arrow_right_rounded : Icons.keyboard_double_arrow_left_rounded,
                color: AppColors.dashMuted,
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
        : AppColors.dashMuted;

    return Tooltip(
      message: collapsed ? item.label : '',
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          padding: EdgeInsets.symmetric(horizontal: collapsed ? 0 : 14, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.cyanDim : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: collapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
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

class _TopBar extends StatelessWidget {
  final String title;
  final bool isMobile;
  final VoidCallback? onMenuTap;

  const _TopBar({required this.title, required this.isMobile, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: AppColors.dashSurface,
        border: Border(bottom: BorderSide(color: AppColors.dashBorder)),
      ),
      child: Row(
        children: [
          if (isMobile && onMenuTap != null)
            IconButton(
              onPressed: onMenuTap,
              icon: const Icon(Icons.menu_rounded, color: AppColors.dashText),
            ),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.cyanDim,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.admin_panel_settings_rounded, size: 14, color: AppColors.cyan),
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