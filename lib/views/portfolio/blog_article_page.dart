import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_portfolio/controllers/blog_controller.dart';
import 'package:flutter_portfolio/data/site_config.dart';
import 'package:flutter_portfolio/models/model.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/utils/open_link.dart';
import 'package:flutter_portfolio/utils/responsive.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BlogArticlePage extends StatelessWidget {
  const BlogArticlePage({super.key});

  BlogModel? _resolve(String id) {
    for (final b in BlogController.to.blogs) {
      if (b.id == id) return b;
    }
    for (final b in BlogController.to.allBlogs) {
      if (b.id == id) return b;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters['id'] ?? '';
    final blog = _resolve(id);
    final isMobile = Responsive.isMobile(context);

    if (blog == null) {
      return Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Note not found', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.offAllNamed('/'),
                child: const Text('Back to home'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.bg,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Get.back();
            } else {
              Get.offAllNamed('/');
            }
          },
        ),
        title: Text(
          'MF',
          style: GoogleFonts.fraunces(color: AppColors.ink, fontWeight: FontWeight.w600),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: EdgeInsets.fromLTRB(isMobile ? 24 : 32, 24, isMobile ? 24 : 32, 80),
            children: [
              Text(
                blog.tags.map((t) => t.toUpperCase()).join('  ·  '),
                style: GoogleFonts.ibmPlexMono(
                  color: AppColors.rust,
                  fontSize: 11,
                  letterSpacing: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              Text(blog.title, style: Theme.of(context).textTheme.displaySmall),
              const SizedBox(height: 16),
              Text(
                '${DateFormat('d MMM yyyy').format(blog.publishedAt)}  ·  ${blog.readTimeMinutes} min  ·  ${SiteConfig.shortName}',
                style: GoogleFonts.ibmPlexMono(color: AppColors.textMuted, fontSize: 12),
              ),
              const SizedBox(height: 28),
              Text(
                blog.excerpt,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.ink),
              ),
              const SizedBox(height: 28),
              const Divider(color: AppColors.border),
              const SizedBox(height: 28),
              MarkdownBody(
                data: blog.content,
                selectable: true,
                onTapLink: (text, href, title) {
                  if (href != null) openUrl(href);
                },
                styleSheet: MarkdownStyleSheet(
                  p: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.ink.withOpacity(0.88),
                        height: 1.75,
                      ),
                  h2: GoogleFonts.fraunces(
                    color: AppColors.ink,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    height: 1.8,
                  ),
                  strong: const TextStyle(
                    color: AppColors.ink,
                    fontWeight: FontWeight.w700,
                  ),
                  listBullet: const TextStyle(color: AppColors.rust),
                  a: const TextStyle(
                    color: AppColors.rust,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              OutlinedButton(
                onPressed: () => Get.offAllNamed('/'),
                child: const Text('Back to the site'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
