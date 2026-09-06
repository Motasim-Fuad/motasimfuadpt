import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

const int maxUploadImageBytes = 1024 * 1024;

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

class ImageTooLargeException implements Exception {
  final int maxBytes;
  final int actualBytes;

  const ImageTooLargeException({
    required this.maxBytes,
    required this.actualBytes,
  });

  @override
  String toString() {
    return 'Image upload size ${formatBytesAsMb(maxBytes)} but your uploading image ${formatBytesAsMb(actualBytes)}';
  }
}

String formatBytesAsMb(int bytes) {
  final mb = bytes / (1024 * 1024);
  if ((mb - mb.round()).abs() < 0.05) {
    return '${mb.round()} MB';
  }
  return '${mb.toStringAsFixed(1)} MB';
}

Future<PickedLocalImage?> pickLocalImage() async {
  final file = await ImagePicker().pickImage(source: ImageSource.gallery);
  if (file == null) return null;
  final size = await file.length();
  if (size > maxUploadImageBytes) {
    throw ImageTooLargeException(
      maxBytes: maxUploadImageBytes,
      actualBytes: size,
    );
  }
  final bytes = await file.readAsBytes();
  return PickedLocalImage(
    bytes: bytes,
    name: file.name,
    contentType: _contentTypeFor(file),
  );
}

String _contentTypeFor(XFile file) {
  final mime = file.mimeType ?? '';
  if (mime.startsWith('image/')) return mime;
  final name = file.name.toLowerCase();
  if (name.endsWith('.png')) return 'image/png';
  if (name.endsWith('.webp')) return 'image/webp';
  if (name.endsWith('.gif')) return 'image/gif';
  return 'image/jpeg';
}

String storageExtFor(String contentType) {
  if (contentType.contains('png')) return 'png';
  if (contentType.contains('webp')) return 'webp';
  return 'jpg';
}
