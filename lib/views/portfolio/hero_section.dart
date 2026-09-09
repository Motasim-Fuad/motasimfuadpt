import 'package:flutter/material.dart';
import 'package:flutter_portfolio/data/site_config.dart';
import 'package:flutter_portfolio/services/firebase_services.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/motion.dart';
import 'package:flutter_portfolio/utils/open_link.dart';
import 'package:flutter_portfolio/utils/remote_image.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/link.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final h = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: isMobile ? 0 : h),
      color: AppColors.bg,
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  isMobile ? 24 : 48,
                  isMobile ? 120 : 140,
                  isMobile ? 24 : 48,
                  isMobile ? 64 : 96,
                ),
                child: isMobile ? const _MobileHero() : const _DesktopHero(),
              ),
            ),
          ),
          if (!isMobile)
            const Positioned(
              left: 0,
              right: 0,
              bottom: 32,
              child: _ScrollCue(),
            ),
        ],
      ),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _HeroCopy()),
        SizedBox(width: 56),
        Expanded(flex: 4, child: _Portrait()),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  const _MobileHero();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        _Portrait(),
        SizedBox(height: 36),
        _HeroCopy(centered: true),
      ],
    );
  }
}

class _HeroCopy extends StatelessWidget {
  final bool centered;
  const _HeroCopy({this.centered = false});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment:
          centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        MotionReveal(
          child: Text(
            '${SiteConfig.role}  ·  ${SiteConfig.location}'.toUpperCase(),
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: GoogleFonts.ibmPlexMono(
              color: AppColors.rust,
              fontSize: 11,
              letterSpacing: 2,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 18),
        MotionReveal(
          delay: const Duration(milliseconds: 80),
          child: Text(
            SiteConfig.name,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: isMobile ? 42 : 62,
                  color: AppColors.ink,
                ),
          ),
        ),
        const SizedBox(height: 20),
        MotionReveal(
          delay: const Duration(milliseconds: 150),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              SiteConfig.tagline,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 17,
                    color: AppColors.ink.withOpacity(0.78),
                  ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        MotionReveal(
          delay: const Duration(milliseconds: 210),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(
              SiteConfig.bio,
              textAlign: centered ? TextAlign.center : TextAlign.start,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const SizedBox(height: 32),
        MotionReveal(
          delay: const Duration(milliseconds: 280),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: centered ? WrapAlignment.center : WrapAlignment.start,
            children: [
              MotionHover(
                lift: 3,
                child: SelectionContainer.disabled(
                  child: Link(
                    uri: parseLaunchUri(SiteConfig.cvUrl),
                    target: LinkTarget.blank,
                    builder: (context, followLink) => ElevatedButton(
                      onPressed: followLink,
                      child: const Text('Download CV'),
                    ),
                  ),
                ),
              ),
              MotionHover(
                lift: 3,
                child: SelectionContainer.disabled(
                  child: Link(
                    uri: parseLaunchUri(SiteConfig.mailUrl),
                    target: LinkTarget.blank,
                    builder: (context, followLink) => OutlinedButton(
                      onPressed: followLink,
                      child: const Text('Write to me'),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        MotionReveal(
          delay: const Duration(milliseconds: 340),
          child: SocialRow(
            alignment:
                centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          ),
        ),
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait();

  @override
  Widget build(BuildContext context) {
    return MotionReveal(
      delay: const Duration(milliseconds: 120),
      slide: MotionSlide.right,
      child: MotionParallax(
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 4 / 5,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.ink, width: 1),
                ),
                child: StreamBuilder<String>(
                  stream: FirebaseService().streamProfileImageUrl(),
                  builder: (context, snapshot) {
                    final waiting = snapshot.connectionState ==
                        ConnectionState.waiting;
                    final url = snapshot.data ?? '';
                    if (waiting && url.isEmpty) {
                      return const ImageShimmer();
                    }
                    if (url.isEmpty) {
                      return const ColoredBox(color: AppColors.surface);
                    }
                    return RemoteImage(
                      url: url,
                      placeholder: (_) => const ImageShimmer(),
                      error: (_) => const ColoredBox(color: AppColors.surface),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const MotionPulseDot(),
                const SizedBox(width: 8),
                Text(
                  'Available for roles',
                  style: GoogleFonts.ibmPlexMono(
                    color: AppColors.forest,
                    fontSize: 11,
                    letterSpacing: 0.6,
                  ),
                ),
                const Spacer(),
                Text(
                  'Flutter · Dart',
                  style: GoogleFonts.ibmPlexMono(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ScrollCue extends StatelessWidget {
  const _ScrollCue();

  @override
  Widget build(BuildContext context) {
    return MotionFadeOnScroll(
      child: MotionReveal(
        delay: const Duration(milliseconds: 780),
        child: Column(
          children: [
            Text(
              'SCROLL',
              style: GoogleFonts.ibmPlexMono(
                color: AppColors.textMuted,
                fontSize: 10,
                letterSpacing: 2.4,
              ),
            ),
            const SizedBox(height: 10),
            const _ScrollStem(),
          ],
        ),
      ),
    );
  }
}

class _ScrollStem extends StatefulWidget {
  const _ScrollStem();

  @override
  State<_ScrollStem> createState() => _ScrollStemState();
}

class _ScrollStemState extends State<_ScrollStem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.disableAnimationsOf(context)) {
      return Container(width: 1, height: 28, color: AppColors.ink);
    }
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        final t = CurvedAnimation(parent: _c, curve: Curves.easeInOut).value;
        return Opacity(
          opacity: 0.35 + (t * 0.65),
          child: Transform.translate(
            offset: Offset(0, t * 6),
            child: Container(width: 1, height: 28, color: AppColors.ink),
          ),
        );
      },
    );
  }
}
