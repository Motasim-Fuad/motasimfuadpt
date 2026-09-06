import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';
import 'package:url_launcher/url_launcher.dart';

Uri? parseLaunchUri(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) return null;
  final parsed = Uri.tryParse(trimmed);
  if (parsed == null) return null;
  if (parsed.hasScheme) return parsed;
  return Uri.parse('https://$trimmed');
}

/// Opens an external URL. On web this must stay in the tap gesture and
/// prefer a real tab (`_blank`) — `LaunchMode.externalApplication` is
/// treated as a popup and Chrome blocks it on the live Vercel site.
Future<void> openUrl(String url) async {
  final uri = parseLaunchUri(url);
  if (uri == null) return;

  if (kIsWeb) {
    await launchUrl(
      uri,
      mode: LaunchMode.platformDefault,
      webOnlyWindowName: '_blank',
    );
    return;
  }

  await launchUrl(uri, mode: LaunchMode.externalApplication);
}

/// Real `<a href>` on Flutter web so links work in production (no popup block).
class WebLink extends StatelessWidget {
  final String url;
  final Widget child;

  const WebLink({super.key, required this.url, required this.child});

  @override
  Widget build(BuildContext context) {
    final uri = parseLaunchUri(url);
    if (uri == null) return child;
    return Link(
      uri: uri,
      target: LinkTarget.blank,
      builder: (context, followLink) {
        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: followLink,
            child: child,
          ),
        );
      },
    );
  }
}
