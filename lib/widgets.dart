import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import 'app_theme.dart';
import 'model.dart';

// ──────────────────────────────────────────────
// GRADIENT TEXT
// ──────────────────────────────────────────────
class GradientText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Gradient gradient;

  const GradientText(
      this.text, {
        super.key,
        this.style,
        this.gradient = AppColors.accentGradient,
      });

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(text, style: style),
    );
  }
}

// ──────────────────────────────────────────────
// SECTION HEADER
// ──────────────────────────────────────────────
class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.cyanDim,
            borderRadius: BorderRadius.circular(100),
            border: Border.all(color: AppColors.cyan.withOpacity(0.3)),
          ),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.spaceGrotesk(
              color: AppColors.cyan,
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
        ),
        const SizedBox(height: 16),
        GradientText(
          title,
          style: Theme.of(context).textTheme.displaySmall,
          gradient: AppColors.accentGradient,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          Text(
            subtitle!,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}

// ──────────────────────────────────────────────
// GLOWING CONTAINER
// ──────────────────────────────────────────────
class GlowCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.cyan,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.06),
            blurRadius: 30,
            spreadRadius: 0,
          ),
        ],
      ),
      child: child,
    );
  }
}

// ──────────────────────────────────────────────
// PROJECT CARD
// ──────────────────────────────────────────────
class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;

  const ProjectCard({super.key, required this.project, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  void _launch(String url) async {
    if (url.isEmpty) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovered ? AppColors.cyan.withOpacity(0.5) : AppColors.border,
          ),
          boxShadow: _hovered
              ? [
            BoxShadow(
              color: AppColors.cyan.withOpacity(0.1),
              blurRadius: 30,
              spreadRadius: 2,
            )
          ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image area
            // Container(
            //   height: 180,
            //   decoration: BoxDecoration(
            //     borderRadius:
            //     const BorderRadius.vertical(top: Radius.circular(20)),
            //     color: AppColors.surface,
            //     image: widget.project.imageUrl.isNotEmpty
            //         ? DecorationImage(
            //       image: NetworkImage(widget.project.imageUrl),
            //       fit: BoxFit.cover,
            //     )
            //         : null,
            //   ),
            //   child: widget.project.imageUrl.isEmpty
            //       ? Center(
            //     child: Icon(
            //       Icons.phone_android_rounded,
            //       size: 60,
            //       color: AppColors.cyan.withOpacity(0.3),
            //     ),
            //   )
            //       : null,
            // ),
            // Image area — এই অংশটা replace করো
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              child: SizedBox(
                height: 180,
                width: double.infinity,
                child: widget.project.imageUrl.isNotEmpty
                    ? Image.network(
                  widget.project.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _ImagePlaceholder(
                    icon: Icons.phone_android_rounded,
                    color: AppColors.cyan,
                  ),
                  loadingBuilder: (_, child, progress) => progress == null
                      ? child
                      : const _ImageLoading(),
                )
                    : _ImagePlaceholder(
                  icon: Icons.phone_android_rounded,
                  color: AppColors.cyan,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.project.featured)
                    Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.cyanDim,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        'Featured',
                        style: GoogleFonts.spaceGrotesk(
                          color: AppColors.cyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1,
                        ),
                      ),
                    ),
                  Text(
                    widget.project.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: widget.project.technologies
                        .take(4)
                        .map((tech) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(6),
                        border:
                        Border.all(color: AppColors.border),
                      ),
                      child: Text(
                        tech,
                        style: GoogleFonts.jetBrainsMono(
                          color: AppColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (widget.project.githubUrl.isNotEmpty)
                        _LinkButton(
                          icon: FontAwesomeIcons.github,
                          label: 'Code',
                          onTap: () => _launch(widget.project.githubUrl),
                        ),
                      const SizedBox(width: 10),
                      if (widget.project.liveUrl.isNotEmpty)
                        _LinkButton(
                          icon: Icons.open_in_new_rounded,
                          label: 'Live',
                          onTap: () => _launch(widget.project.liveUrl),
                          isCyan: true,
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: (widget.index * 100).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

class _LinkButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final VoidCallback onTap;
  final bool isCyan;

  const _LinkButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isCyan = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isCyan ? AppColors.cyanDim : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCyan
                ? AppColors.cyan.withOpacity(0.4)
                : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon is IconData
                ? Icon(icon as IconData,
                size: 13,
                color: isCyan ? AppColors.cyan : AppColors.textSecondary)
                : FaIcon(icon as IconData,
                size: 13,
                color: isCyan ? AppColors.cyan : AppColors.textSecondary),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.spaceGrotesk(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isCyan ? AppColors.cyan : AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────
// SKILL BAR
// ──────────────────────────────────────────────
class SkillBar extends StatelessWidget {
  final SkillModel skill;
  final int index;

  const SkillBar({super.key, required this.skill, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                skill.name,
                style: GoogleFonts.spaceGrotesk(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '${skill.proficiency}%',
                style: GoogleFonts.jetBrainsMono(
                  color: AppColors.cyan,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(100),
            ),
            child: LayoutBuilder(builder: (context, constraints) {
              return Stack(
                children: [
                  Container(
                    width: constraints.maxWidth *
                        (skill.proficiency / 100),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.cyan, AppColors.purple],
                      ),
                      borderRadius: BorderRadius.circular(100),
                    ),
                  )
                      .animate(delay: (index * 80 + 300).ms)
                      .slideX(begin: -1, end: 0, duration: 800.ms,
                      curve: Curves.easeOutCubic),
                ],
              );
            }),
          ),
        ],
      ),
    ).animate(delay: (index * 60).ms).fadeIn(duration: 400.ms);
  }
}

// ──────────────────────────────────────────────
// BLOG CARD
// ──────────────────────────────────────────────
class BlogCard extends StatelessWidget {
  final BlogModel blog;
  final int index;

  const BlogCard({super.key, required this.blog, required this.index});

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Container(
          //   height: 160,
          //   decoration: BoxDecoration(
          //     borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          //     color: AppColors.surface,
          //     image: blog.imageUrl.isNotEmpty
          //         ? DecorationImage(
          //       image: NetworkImage(blog.imageUrl),
          //       fit: BoxFit.cover,
          //     )
          //         : null,
          //   ),
          //   child: blog.imageUrl.isEmpty
          //       ? Center(
          //       child: Icon(Icons.article_rounded,
          //           size: 50, color: AppColors.purple.withOpacity(0.3)))
          //       : null,
          // ),
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: SizedBox(
              height: 160,
              width: double.infinity,
              child: blog.imageUrl.isNotEmpty
                  ? Image.network(
                blog.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _ImagePlaceholder(
                  icon: Icons.article_rounded,
                  color: AppColors.purple,
                ),
                loadingBuilder: (_, child, progress) => progress == null
                    ? child
                    : const _ImageLoading(),
              )
                  : _ImagePlaceholder(
                icon: Icons.article_rounded,
                color: AppColors.purple,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 6,
                  children: blog.tags
                      .take(2)
                      .map((tag) => Text(
                    '#$tag',
                    style: GoogleFonts.spaceGrotesk(
                      color: AppColors.purple,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ))
                      .toList(),
                ),
                const SizedBox(height: 10),
                Text(
                  blog.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 16,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  blog.excerpt,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.schedule_rounded,
                        size: 14, color: AppColors.textMuted),
                    const SizedBox(width: 4),
                    Text(
                      '${blog.readTimeMinutes} min read',
                      style: GoogleFonts.inter(
                          color: AppColors.textMuted, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.2, end: 0);
  }
}

// ──────────────────────────────────────────────
// STATS CARD
// ──────────────────────────────────────────────
class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final int index;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withOpacity(0.2)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 16),
          GradientText(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 32,
              fontWeight: FontWeight.w800,
            ),
            gradient: LinearGradient(colors: [color, color.withOpacity(0.6)]),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate(delay: (index * 100).ms)
        .fadeIn(duration: 500.ms)
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }


}

class _ImagePlaceholder extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _ImagePlaceholder({required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: Center(
        child: Icon(icon, size: 52, color: color.withOpacity(0.25)),
      ),
    );
  }
}

class _ImageLoading extends StatelessWidget {
  const _ImageLoading();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            color: AppColors.cyan,
            strokeWidth: 2,
          ),
        ),
      ),
    );
  }
}