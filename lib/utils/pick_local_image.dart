import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PickedLocalImage {
  final Uint8List bytes;
  final String name;
  final String contentType;

  const PickedLocalImage({
    required this.bytes,
    required this.name,
    required this.contentType,
  });
}

Future<PickedLocalImage?> pickLocalImage() async {
  final file = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    imageQuality: 62,
    maxWidth: 900,
  );
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  if (bytes.length > 550 * 1024) {
    throw Exception(
      'Photo is still ${(bytes.length / 1024).round()} KB after compression. '
      'Choose a smaller picture.',
    );
  }
  return PickedLocalImage(
    bytes: bytes,
    name: file.name,
    contentType: 'image/jpeg',
  );
}

String storageExtFor(String contentType) {
  if (contentType.contains('png')) return 'png';
  if (contentType.contains('webp')) return 'webp';
  return 'jpg';
}
