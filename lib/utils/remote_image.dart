import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';

/// Turns share/view links into a URL a browser `<img>` can actually load.
String resolveImageUrl(String raw) {
  var url = raw.trim();
  if ((url.startsWith('"') && url.endsWith('"')) ||
      (url.startsWith("'") && url.endsWith("'"))) {
    url = url.substring(1, url.length - 1).trim();
  }
  if (url.isEmpty) return url;

  final driveFile = RegExp(r'drive\.google\.com/file/d/([^/]+)').firstMatch(url);
  if (driveFile != null) {
    final id = driveFile.group(1)!;
    return 'https://drive.google.com/uc?export=view&id=$id';
  }

  if (url.contains('drive.google.com')) {
    final id = RegExp(r'[?&]id=([^&]+)').firstMatch(url)?.group(1);
    if (id != null && id.isNotEmpty) {
      return 'https://drive.google.com/uc?export=view&id=$id';
    }
  }

  final blob = RegExp(
    r'^https://github\.com/([^/]+)/([^/]+)/blob/([^/]+)/(.+)$',
  ).firstMatch(url);
  if (blob != null) {
    return 'https://raw.githubusercontent.com/${blob.group(1)}/${blob.group(2)}/${blob.group(3)}/${blob.group(4)}';
  }

  if (url.contains('dropbox.com') && url.contains('dl=0')) {
    return url.replaceAll('dl=0', 'raw=1');
  }

  return url;
}

class RemoteImage extends StatelessWidget {
  final String url;
  final BoxFit fit;
  final Widget Function(BuildContext context) placeholder;
  final Widget Function(BuildContext context) error;

  const RemoteImage({
    super.key,
    required this.url,
    required this.placeholder,
    required this.error,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final resolved = resolveImageUrl(url);
    if (resolved.isEmpty) return placeholder(context);

    if (resolved.startsWith('data:image/')) {
      const marker = 'base64,';
      final at = resolved.indexOf(marker);
      if (at < 0) return error(context);
      try {
        final bytes = base64Decode(resolved.substring(at + marker.length));
        return Image.memory(
          bytes,
          fit: fit,
          width: double.infinity,
          height: double.infinity,
          gaplessPlayback: true,
          errorBuilder: (context, _, __) => error(context),
        );
      } catch (_) {
        return error(context);
      }
    }

    return Image.network(
      resolved,
      fit: fit,
      width: double.infinity,
      height: double.infinity,
      gaplessPlayback: true,
      webHtmlElementStrategy: kIsWeb
          ? WebHtmlElementStrategy.prefer
          : WebHtmlElementStrategy.never,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return placeholder(context);
      },
      errorBuilder: (context, _, __) => error(context),
    );
  }
}

class ImageShimmer extends StatelessWidget {
  final bool onDark;

  const ImageShimmer({super.key, this.onDark = false});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: onDark ? AppColors.dashSurface : AppColors.surface,
      child: const SizedBox.expand(),
    )
        .animate(onPlay: (c) => c.repeat())
        .shimmer(
          duration: 1200.ms,
          color: onDark ? AppColors.dashBorder : const Color(0xFFE4D9C8),
        );
  }
}
