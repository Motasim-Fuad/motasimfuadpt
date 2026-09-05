import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/data/site_config.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/open_link.dart';
import 'package:flutter_portfolio/utils/remote_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/model.dart';

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
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String label;
  final String title;
  final String? subtitle;
  final bool alignStart;

  const SectionHeader({
    super.key,
    required this.label,
    required this.title,
    this.subtitle,
    this.alignStart = false,
  });

  @override
  Widget build(BuildContext context) {
    final align = alignStart ? CrossAxisAlignment.start : CrossAxisAlignment.center;
    final textAlign = alignStart ? TextAlign.start : TextAlign.center;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: GoogleFonts.ibmPlexMono(
            color: AppColors.rust,
            fontSize: 12,
            letterSpacing: 2.2,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.displaySmall,
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: textAlign,
            ),
          ),
        ],
      ],
    ).animate().fadeIn(duration: 500.ms);
  }
}

class GlowCard extends StatelessWidget {
  final Widget child;
  final Color glowColor;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  const GlowCard({
    super.key,
    required this.child,
    this.glowColor = AppColors.rust,
    this.padding,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: padding ?? const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: dark ? AppColors.dashCard : AppColors.card,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
        border: Border.all(color: dark ? AppColors.dashBorder : AppColors.border),
      ),
      child: child,
    );
  }
}

class ProjectCard extends StatefulWidget {
  final ProjectModel project;
  final int index;

  const ProjectCard({super.key, required this.project, required this.index});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        decoration: BoxDecoration(
          color: _hovered ? AppColors.cardHover : AppColors.card,
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 168,
              width: double.infinity,
              child: widget.project.imageUrl.isNotEmpty
                  ? RemoteImage(
                      url: widget.project.imageUrl,
                      placeholder: (_) => _IndexPlate(index: widget.index),
                      error: (_) => _IndexPlate(index: widget.index),
                    )
                  : _IndexPlate(index: widget.index),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.project.featured)
                    Text(
                      'SELECTED',
                      style: GoogleFonts.ibmPlexMono(
                        color: AppColors.rust,
                        fontSize: 10,
                        letterSpacing: 1.6,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  if (widget.project.featured) const SizedBox(height: 8),
                  Text(
                    widget.project.title,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.project.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 14),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: widget.project.technologies
                        .take(4)
                        .map(
                          (tech) => Text(
                            tech,
                            style: GoogleFonts.ibmPlexMono(
                              color: AppColors.forest,
                              fontSize: 11,
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 14,
                    runSpacing: 8,
                    children: [
                      if (widget.project.appStoreUrl.isNotEmpty)
                        _TextLink(
                          label: 'App Store',
                          onTap: () => openUrl(widget.project.appStoreUrl),
                          rust: true,
                        ),
                      if (widget.project.playStoreUrl.isNotEmpty)
                        _TextLink(
                          label: 'Play Store',
                          onTap: () => openUrl(widget.project.playStoreUrl),
                          rust: true,
                        ),
                      if (widget.project.githubUrl.isNotEmpty)
                        _TextLink(
                          label: 'Code',
                          onTap: () => openUrl(widget.project.githubUrl),
                        ),
                      if (widget.project.liveUrl.isNotEmpty)
                        _TextLink(
                          label: 'Live',
                          onTap: () => openUrl(widget.project.liveUrl),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).animate(delay: (widget.index * 80).ms).fadeIn(duration: 450.ms);
  }
}

class _IndexPlate extends StatelessWidget {
  final int index;
  const _IndexPlate({required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.forest,
      padding: const EdgeInsets.all(20),
      alignment: Alignment.bottomLeft,
      child: Text(
        (index + 1).toString().padLeft(2, '0'),
        style: GoogleFonts.fraunces(
          color: AppColors.bg,
          fontSize: 48,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

class _TextLink extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool rust;

  const _TextLink({required this.label, required this.onTap, this.rust = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.outfit(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: rust ? AppColors.rust : AppColors.ink,
          decoration: TextDecoration.underline,
          decorationColor: rust ? AppColors.rust : AppColors.ink,
        ),
      ),
    );
  }
}

class SkillBar extends StatelessWidget {
  final SkillModel skill;
  final int index;

  const SkillBar({super.key, required this.skill, required this.index});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              skill.name,
              style: GoogleFonts.outfit(
                color: AppColors.ink,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
          Text(
            '${skill.proficiency}',
            style: GoogleFonts.ibmPlexMono(
              color: AppColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 40).ms).fadeIn(duration: 350.ms);
  }
}

class BlogCard extends StatefulWidget {
  final BlogModel blog;
  final int index;

  const BlogCard({super.key, required this.blog, required this.index});

  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => Get.toNamed('/notes/${widget.blog.id}'),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: _hovered ? AppColors.cardHover : AppColors.card,
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.blog.tags.take(2).map((t) => t.toUpperCase()).join('  ·  '),
                style: GoogleFonts.ibmPlexMono(
                  color: AppColors.rust,
                  fontSize: 10,
                  letterSpacing: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                widget.blog.title,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(height: 1.25),
              ),
              const SizedBox(height: 10),
              Text(
                widget.blog.excerpt,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const Spacer(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    '${widget.blog.readTimeMinutes} min',
                    style: GoogleFonts.ibmPlexMono(
                      color: AppColors.textMuted,
                      fontSize: 11,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    _hovered ? 'Read →' : 'Read',
                    style: GoogleFonts.outfit(
                      color: AppColors.rust,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: (widget.index * 80).ms).fadeIn(duration: 450.ms);
  }
}

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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: GoogleFonts.fraunces(
              fontSize: 36,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.outfit(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    ).animate(delay: (index * 70).ms).fadeIn(duration: 400.ms);
  }
}

class SocialRow extends StatelessWidget {
  final MainAxisAlignment alignment;
  final bool onDark;
  const SocialRow({
    super.key,
    this.alignment = MainAxisAlignment.start,
    this.onDark = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        _SocialIcon(
          icon: FontAwesomeIcons.github,
          url: SiteConfig.githubUrl,
          tooltip: 'GitHub',
          onDark: onDark,
        ),
        const SizedBox(width: 10),
        _SocialIcon(
          icon: FontAwesomeIcons.linkedinIn,
          url: SiteConfig.linkedInUrl,
          tooltip: 'LinkedIn',
          onDark: onDark,
        ),
        const SizedBox(width: 10),
        _SocialIcon(
          icon: FontAwesomeIcons.code,
          url: SiteConfig.leetCodeUrl,
          tooltip: 'LeetCode',
          onDark: onDark,
        ),
      ],
    );
  }
}

class _SocialIcon extends StatefulWidget {
  final FaIconData icon;
  final String url;
  final String tooltip;
  final bool onDark;

  const _SocialIcon({
    required this.icon,
    required this.url,
    required this.tooltip,
    this.onDark = false,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: () => openUrl(widget.url),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: _hover
                  ? (widget.onDark ? AppColors.bg : AppColors.ink)
                  : Colors.transparent,
              border: Border.all(
                color: widget.onDark ? AppColors.bg : AppColors.ink,
              ),
            ),
            child: Center(
              child: FaIcon(
                widget.icon,
                size: 16,
                color: _hover
                    ? (widget.onDark ? AppColors.ink : AppColors.bg)
                    : (widget.onDark ? AppColors.bg : AppColors.ink),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
