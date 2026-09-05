import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  if (url.isEmpty) return;
  final uri = Uri.parse(url);
  await launchUrl(uri, mode: LaunchMode.externalApplication);
}
