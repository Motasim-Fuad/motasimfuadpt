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
    imageQuality: 88,
    maxWidth: 2000,
  );
  if (file == null) return null;
  final bytes = await file.readAsBytes();
  if (bytes.length > 8 * 1024 * 1024) {
    throw Exception('Image is larger than 8 MB');
  }
  final name = file.name.toLowerCase();
  final contentType = name.endsWith('.png')
      ? 'image/png'
      : name.endsWith('.webp')
          ? 'image/webp'
          : 'image/jpeg';
  return PickedLocalImage(bytes: bytes, name: file.name, contentType: contentType);
}

String storageExtFor(String contentType) {
  if (contentType.contains('png')) return 'png';
  if (contentType.contains('webp')) return 'webp';
  return 'jpg';
}
