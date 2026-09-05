import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/blog_controller.dart';
import '../controllers/contact_controller.dart';
import '../controllers/profile_controller.dart';
import '../controllers/project_controller.dart';
import '../controllers/skill_controller.dart';
import '../controllers/stats_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(ProjectController(), permanent: true);
    Get.put(SkillController(), permanent: true);
    Get.put(BlogController(), permanent: true);
    Get.put(ContactController(), permanent: true);
    Get.put(StatsController(), permanent: true);
    Get.put(ProfileController(), permanent: true);
  }
}