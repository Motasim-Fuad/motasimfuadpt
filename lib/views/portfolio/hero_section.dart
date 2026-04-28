import 'dart:math';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  void _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      decoration: const BoxDecoration(color: AppColors.bg),
      child: Stack(
        children: [
          Positioned.fill(child: _GridBackground()),
          Positioned(
            top: -100,
            right: -100,
            child: _GlowOrb(color: AppColors.cyan, size: 400),
          ),
          Positioned(
            bottom: 0,
            left: -150,
            child: _GlowOrb(color: AppColors.purple, size: 350),
          ),
          Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 1200),
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 24 : 48,
                vertical: 100,
              ),
              child: isMobile
                  ? _MobileHero(onLaunch: _launch)
                  : _DesktopHero(onLaunch: _launch),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(child: _ScrollIndicator()),
          ),
        ],
      ),
    );
  }
}

class _DesktopHero extends StatelessWidget {
  final Function(String) onLaunch;
  const _DesktopHero({required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(flex: 6, child: _HeroText(onLaunch: onLaunch)),
        const SizedBox(width: 60),
        Expanded(flex: 4, child: _ProfileImage()),
      ],
    );
  }
}

class _MobileHero extends StatelessWidget {
  final Function(String) onLaunch;
  const _MobileHero({required this.onLaunch});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _ProfileImage(),
        const SizedBox(height: 40),
        _HeroText(onLaunch: onLaunch, centered: true),
      ],
    );
  }
}

class _HeroText extends StatelessWidget {
  final Function(String) onLaunch;
  final bool centered;
  const _HeroText({required this.onLaunch, this.centered = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      centered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cyanDim,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: AppColors.cyan,
                  shape: BoxShape.circle,
                ),
              ).animate(onPlay: (c) => c.repeat())
                  .scaleXY(end: 1.5, duration: 800.ms)
                  .then()
                  .scaleXY(end: 1, duration: 800.ms),
              const SizedBox(width: 8),
              Text(
                'Available for hire',
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.cyan,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 200.ms).slideX(begin: -0.2, end: 0),
        const SizedBox(height: 24),
        Text(
          'Hi, I\'m',
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w400,
            fontSize: 22,
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 300.ms),
        const SizedBox(height: 4),
        GradientText(
          'Md Motasim Fuad',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontSize: Responsive.isMobile(context) ? 48 : 72,
          ),
          gradient: AppColors.accentGradient,
        ).animate().fadeIn(duration: 600.ms, delay: 400.ms).slideY(begin: 0.3, end: 0),
        const SizedBox(height: 12),
        DefaultTextStyle(
          style: GoogleFonts.spaceGrotesk(
            color: AppColors.textSecondary,
            fontSize: Responsive.isMobile(context) ? 18 : 22,
            fontWeight: FontWeight.w500,
          ),
          child: Row(
            mainAxisSize: centered ? MainAxisSize.min : MainAxisSize.max,
            children: [
              Text('I build ', style: TextStyle(color: AppColors.textSecondary)),
              AnimatedTextKit(
                repeatForever: true,
                animatedTexts: [
                  TypewriterAnimatedText(
                    'Flutter Apps.',
                    textStyle: GoogleFonts.spaceGrotesk(
                      color: AppColors.cyan,
                      fontWeight: FontWeight.w700,
                      fontSize: Responsive.isMobile(context) ? 18 : 22,
                    ),
                    speed: const Duration(milliseconds: 80),
                  ),
                  TypewriterAnimatedText(
                    'Mobile Experiences.',
                    textStyle: GoogleFonts.spaceGrotesk(
                      color: AppColors.purple,
                      fontWeight: FontWeight.w700,
                      fontSize: Responsive.isMobile(context) ? 18 : 22,
                    ),
                    speed: const Duration(milliseconds: 70),
                  ),
                  TypewriterAnimatedText(
                    'Beautiful UIs.',
                    textStyle: GoogleFonts.spaceGrotesk(
                      color: AppColors.green,
                      fontWeight: FontWeight.w700,
                      fontSize: Responsive.isMobile(context) ? 18 : 22,
                    ),
                    speed: const Duration(milliseconds: 90),
                  ),
                ],
              ),
            ],
          ),
        ).animate().fadeIn(duration: 600.ms, delay: 600.ms),
        const SizedBox(height: 20),
        Text(
          'Flutter & Mobile Developer passionate about crafting beautiful,\nperformant applications with exceptional user experiences.',
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(fontSize: 15, height: 1.8),
          textAlign: centered ? TextAlign.center : TextAlign.start,
        ).animate().fadeIn(duration: 600.ms, delay: 700.ms),
        const SizedBox(height: 36),
        Wrap(
          spacing: 14,
          runSpacing: 14,
          alignment: centered ? WrapAlignment.center : WrapAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                onLaunch('https://drive.google.com/file/d/18JN18158887/view?usp=drivesdk');
              },
              icon: const Icon(Icons.download_rounded, size: 18),
              label: const Text('Download CV'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                onLaunch('https://mail.google.com/mail/?view=cm&fs=1&to=motasimfuad@gmail.com');
              },
              icon: const Icon(Icons.mail_outline_rounded, size: 18),
              label: const Text('Contact Me'),
            ),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 800.ms),
        const SizedBox(height: 40),
        Row(
          mainAxisAlignment: centered ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _SocialLink(
              icon: FontAwesomeIcons.github,
              url: 'https://github.com/motasimfuad',
              tooltip: 'GitHub',
            ),
            const SizedBox(width: 16),
            _SocialLink(
              icon: FontAwesomeIcons.linkedin,
              url: 'https://linkedin.com/in/motasimfuad',
              tooltip: 'LinkedIn',
            ),
            const SizedBox(width: 16),
            _SocialLink(
              icon: FontAwesomeIcons.twitter,
              url: 'https://twitter.com/motasimfuad',
              tooltip: 'Twitter',
            ),
          ],
        ).animate().fadeIn(duration: 600.ms, delay: 900.ms),
      ],
    );
  }
}

class _ProfileImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  AppColors.cyan,
                  AppColors.purple,
                  Colors.transparent,
                  AppColors.cyan,
                ],
              ),
            ),
          ).animate(onPlay: (c) => c.repeat()).rotate(duration: 4000.ms, curve: Curves.linear),
          Container(
            width: 285,
            height: 285,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.card,
              border: Border.all(color: AppColors.bg, width: 4),
              image: const DecorationImage(
                image: AssetImage('assets/profile_picture.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withOpacity(0.15),
                    blurRadius: 20,
                  )
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FaIcon(FontAwesomeIcons.flutter,
                      color: AppColors.cyan, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Flutter Dev',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ).animate(onPlay: (c) => c.repeat(reverse: true)).moveY(
                begin: 0, end: -10, duration: 2000.ms, curve: Curves.easeInOut),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 400.ms)
        .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}

class _SocialLink extends StatelessWidget {
  final IconData icon;
  final String url;
  final String tooltip;

  const _SocialLink({required this.icon, required this.url, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: () async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) launchUrl(uri);
        },
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Center(child: FaIcon(icon, size: 18, color: AppColors.textSecondary)),
        ),
      ),
    );
  }
}

class _ScrollIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Scroll down',
          style: GoogleFonts.spaceGrotesk(
              color: AppColors.textMuted, fontSize: 11, letterSpacing: 2),
        ),
        const SizedBox(height: 8),
        Container(
          width: 1,
          height: 50,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.cyan, Colors.transparent],
            ),
          ),
        ),
      ],
    ).animate(onPlay: (c) => c.repeat(reverse: true))
        .fadeIn(duration: 1000.ms)
        .then(delay: 500.ms)
        .fadeOut(duration: 1000.ms);
  }
}

class _GridBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _GridPainter(),
      child: Container(),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1A2235).withOpacity(0.4)
      ..strokeWidth = 1;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GlowOrb extends StatelessWidget {
  final Color color;
  final double size;

  const _GlowOrb({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 150,
            spreadRadius: 50,
          ),
        ],
      ),
    );
  }
}