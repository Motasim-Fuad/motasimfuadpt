import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/data/site_config.dart';
import 'package:flutter_portfolio/services/firebase_services.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
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
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isMobile ? 24 : 48,
              isMobile ? 120 : 140,
              isMobile ? 24 : 48,
              isMobile ? 64 : 80,
            ),
            child: isMobile ? const _MobileHero() : const _DesktopHero(),
          ),
        ),
      ),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  const _DesktopHero();

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Expanded(flex: 6, child: _HeroCopy()),
        const SizedBox(width: 56),
        const Expanded(flex: 4, child: _Portrait()),
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
        Text(
          '${SiteConfig.role}  ·  ${SiteConfig.location}'.toUpperCase(),
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: GoogleFonts.ibmPlexMono(
            color: AppColors.rust,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.w500,
          ),
        ).animate().fadeIn(duration: 500.ms),
        const SizedBox(height: 18),
        Text(
          SiteConfig.name,
          textAlign: centered ? TextAlign.center : TextAlign.start,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: isMobile ? 42 : 62,
                color: AppColors.ink,
              ),
        ).animate().fadeIn(duration: 600.ms, delay: 80.ms),
        const SizedBox(height: 20),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            SiteConfig.tagline,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: 17,
                  color: AppColors.ink.withOpacity(0.78),
                ),
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 140.ms),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Text(
            SiteConfig.bio,
            textAlign: centered ? TextAlign.center : TextAlign.start,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 180.ms),
        const SizedBox(height: 32),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            Link(
              uri: parseLaunchUri(SiteConfig.cvUrl),
              target: LinkTarget.blank,
              builder: (context, followLink) => ElevatedButton(
                onPressed: followLink,
                child: const Text('Download CV'),
              ),
            ),
            Link(
              uri: parseLaunchUri(SiteConfig.mailUrl),
              target: LinkTarget.blank,
              builder: (context, followLink) => OutlinedButton(
                onPressed: followLink,
                child: const Text('Write to me'),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 500.ms, delay: 240.ms),
        const SizedBox(height: 28),
        SocialRow(
          alignment:
              centered ? MainAxisAlignment.center : MainAxisAlignment.start,
        ).animate().fadeIn(duration: 500.ms, delay: 280.ms),
      ],
    );
  }
}

class _Portrait extends StatelessWidget {
  const _Portrait();

  @override
  Widget build(BuildContext context) {
    return Column(
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
                final url = snapshot.data ?? '';
                if (url.isNotEmpty) {
                  return RemoteImage(
                    url: url,
                    placeholder: (_) => const PortraitFallback(),
                    error: (_) => const PortraitFallback(),
                  );
                }
                return const PortraitFallback();
              },
            ),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
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
    ).animate().fadeIn(duration: 700.ms, delay: 120.ms);
  }
}
