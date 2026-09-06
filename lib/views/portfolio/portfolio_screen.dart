import 'package:flutter/material.dart';
import 'package:flutter_portfolio/data/site_config.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/open_link.dart';
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
  final _sections = ['Home', 'About', 'Work', 'Stack', 'Notes', 'Contact'];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final show = _scrollController.offset > 40;
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
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
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
                KeyedSubtree(key: _navKeys[1], child: const AboutSection()),
                KeyedSubtree(key: _navKeys[2], child: const ProjectsSection()),
                KeyedSubtree(key: _navKeys[3], child: const SkillsSection()),
                const StatsSection(),
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
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      decoration: BoxDecoration(
        color: showBg ? AppColors.bg.withOpacity(0.96) : Colors.transparent,
        border: Border(
          bottom: BorderSide(
            color: showBg ? AppColors.border : Colors.transparent,
          ),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => onTap(0),
                child: Text(
                  'MF',
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
              const Spacer(),
              if (!isMobile)
                Row(
                  children: sections.asMap().entries.skip(1).map((entry) {
                    final isActive = entry.key == activeIndex;
                    return Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: GestureDetector(
                        onTap: () => onTap(entry.key),
                        child: Text(
                          entry.value,
                          style: GoogleFonts.outfit(
                            color: isActive ? AppColors.rust : AppColors.ink,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                )
              else
                IconButton(
                  icon: const Icon(Icons.menu, color: AppColors.ink),
                  onPressed: () => _showMobileMenu(context),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(8, 16, 8, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...sections.asMap().entries.map(
              (entry) => ListTile(
                title: Text(
                  entry.value,
                  style: GoogleFonts.fraunces(
                    color: entry.key == activeIndex ? AppColors.rust : AppColors.ink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  onTap(entry.key);
                },
              ),
            ),
            ListTile(
              title: Text(
                'Download CV',
                style: GoogleFonts.outfit(color: AppColors.rust, fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.pop(context);
                openUrl(SiteConfig.cvUrl);
              },
            ),
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
      color: AppColors.ink,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    SiteConfig.shortName,
                    style: GoogleFonts.fraunces(
                      color: AppColors.bg,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => openUrl(SiteConfig.cvUrl),
                    child: Text(
                      'CV',
                      style: GoogleFonts.outfit(color: AppColors.bg),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const SocialRow(alignment: MainAxisAlignment.start, onDark: true),
              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '© ${DateTime.now().year}  ·  Motasim Fuad',
                  style: GoogleFonts.ibmPlexMono(
                    color: AppColors.bg.withOpacity(0.55),
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
