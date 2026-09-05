import 'package:get/get.dart';
import '../services/firebase_services.dart';
import '../utils/pick_local_image.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  final _service = FirebaseService();
  final imageUrl = ''.obs;
  final uploading = false.obs;
  final error = RxnString();

  @override
  void onInit() {
    super.onInit();
    _service.streamProfileImageUrl().listen((url) {
      imageUrl.value = url;
    });
  }

  Future<void> uploadFromDevice() async {
    error.value = null;
    try {
      final picked = await pickLocalImage();
      if (picked == null) return;
      uploading.value = true;
      final ext = storageExtFor(picked.contentType);
      final url = await _service.uploadImageBytes(
        bytes: picked.bytes,
        storagePath: 'profile/avatar_${DateTime.now().millisecondsSinceEpoch}.$ext',
        contentType: picked.contentType,
      );
      await _service.setProfileImageUrl(url);
    } catch (e) {
      error.value = e.toString();
    } finally {
      uploading.value = false;
    }
  }
}
