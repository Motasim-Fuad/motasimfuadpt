import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:flutter_portfolio/views/portfolio/hero_section.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_sections.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:google_fonts/google_fonts.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  final _scrollController = ScrollController();
  bool _showNavBg = false;
  int _activeNav = 0;

  final _navKeys = List.generate(6, (_) => GlobalKey());
  final _sections = [
    'Home',
    'Projects',
    'Skills',
    'Stats',
    'Blog',
    'Contact',
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 50;
      if (show != _showNavBg) setState(() => _showNavBg = show);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollTo(int index) {
    final ctx = _navKeys[index].currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(ctx,
          duration: const Duration(milliseconds: 700), curve: Curves.easeInOut);
    }
    setState(() => _activeNav = index);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Scaffold(
      backgroundColor: AppColors.bg,
      extendBodyBehindAppBar: true,
      appBar: _NavBar(
        showBg: _showNavBg,
        activeIndex: _activeNav,
        sections: _sections,
        isMobile: isMobile,
        onTap: _scrollTo,
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                KeyedSubtree(key: _navKeys[0], child: const HeroSection()),
                KeyedSubtree(key: _navKeys[1], child: const ProjectsSection()),
                KeyedSubtree(key: _navKeys[2], child: const SkillsSection()),
                KeyedSubtree(key: _navKeys[3], child: const StatsSection()),
                KeyedSubtree(key: _navKeys[4], child: const BlogSection()),
                KeyedSubtree(key: _navKeys[5], child: const ContactSection()),
                const _Footer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBg;
  final int activeIndex;
  final List<String> sections;
  final bool isMobile;
  final Function(int) onTap;

  const _NavBar({
    required this.showBg,
    required this.activeIndex,
    required this.sections,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(70);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: showBg
            ? AppColors.surface.withOpacity(0.95)
            : Colors.transparent,
        border: showBg
            ? const Border(bottom: BorderSide(color: AppColors.border, width: 1))
            : null,
        boxShadow: showBg
            ? [BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 20)]
            : [],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              GradientText(
                'Motasim Fuad',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 18, fontWeight: FontWeight.w700),
                gradient: AppColors.accentGradient,
              ),
              const Spacer(),
              if (!isMobile)
                Row(
                  children: sections.asMap().entries.map((entry) {
                    final isActive = entry.key == activeIndex;
                    return GestureDetector(
                      onTap: () => onTap(entry.key),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.cyanDim : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          entry.value,
                          style: GoogleFonts.spaceGrotesk(
                            color: isActive
                                ? AppColors.cyan
                                : AppColors.textSecondary,
                            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu_rounded, color: AppColors.textPrimary),
                  onPressed: () => _showMobileMenu(context),
                ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 600.ms);
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 24),
            ...sections.asMap().entries.map((entry) => ListTile(
              title: Text(
                entry.value,
                style: GoogleFonts.spaceGrotesk(
                  color: entry.key == activeIndex
                      ? AppColors.cyan
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: entry.key == activeIndex
                  ? const Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.cyan)
                  : null,
              onTap: () {
                Navigator.pop(context);
                onTap(entry.key);
              },
            )),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Column(
        children: [
          const Divider(color: AppColors.border),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientText(
                'Motasim Fuad',
                style: GoogleFonts.spaceGrotesk(
                    fontSize: 16, fontWeight: FontWeight.w700),
                gradient: AppColors.accentGradient,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '© ${DateTime.now().year} Md Motasim Fuad. Built with Flutter & Firebase.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}