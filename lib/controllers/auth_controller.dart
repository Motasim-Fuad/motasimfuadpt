import 'package:get/get.dart';
import '../services/firebase_services.dart';

class AuthController extends GetxController {
  static AuthController get to => Get.find();

  final _service = FirebaseService();
  final isLoading = false.obs;
  final errorMsg = RxnString();

  bool get isAdmin => _service.isAdmin;

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    errorMsg.value = null;
    final user = await _service.signIn(email, password);
    isLoading.value = false;
    if (user != null) {
      Get.offAllNamed('/dashboard');
    } else {
      errorMsg.value = 'Invalid email or password. Please try again.';
    }
  }

  Future<void> signOut() async {
    await _service.signOut();
    Get.offAllNamed('/');
  }
}