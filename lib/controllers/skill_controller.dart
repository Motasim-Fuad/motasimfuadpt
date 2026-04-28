import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class SkillController extends GetxController {
  static SkillController get to => Get.find();

  final _service = FirebaseService();
  final skills = <SkillModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _service.streamSkills().listen((list) {
      skills.value = list;
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);
  }

  Future<void> add(SkillModel skill) async {
    await _service.addSkill(skill);
  }

  Future<void> updateSkill(SkillModel skill) async {
    await _service.updateSkill(skill);
  }

  Future<void> delete(String id) async {
    await _service.deleteSkill(id);
  }

  Map<String, List<SkillModel>> get byCategory {
    final map = <String, List<SkillModel>>{};
    for (final s in skills) {
      map.putIfAbsent(s.category, () => []).add(s);
    }
    return map;
  }
}