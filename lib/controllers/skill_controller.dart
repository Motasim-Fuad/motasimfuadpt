import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class SkillController extends GetxController {
  static SkillController get to => Get.find();

  final _service = FirebaseService();
  final skills = <SkillModel>[].obs;
  final isLoading = true.obs;
  var _busy = false;
  var _deduped = false;

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

  Future<void> _waitUntilLoaded() async {
    if (!isLoading.value) return;
    await isLoading.stream.firstWhere((loading) => !loading).timeout(
          const Duration(seconds: 12),
          onTimeout: () => false,
        );
  }

  /// Deletes extra Firestore docs that share the same skill name.
  Future<int> removeDuplicateNames() async {
    if (_busy) return 0;
    _busy = true;
    try {
      await _waitUntilLoaded();
      final seen = <String>{};
      final extras = <SkillModel>[];
      for (final skill in skills) {
        final key = skill.name.trim().toLowerCase();
        if (key.isEmpty) continue;
        if (seen.contains(key)) {
          extras.add(skill);
        } else {
          seen.add(key);
        }
      }
      for (final skill in extras) {
        await delete(skill.id);
      }
      _deduped = true;
      return extras.length;
    } finally {
      _busy = false;
    }
  }

  Future<void> cleanupDuplicatesOnce() async {
    if (_deduped) return;
    await removeDuplicateNames();
  }

  Map<String, List<SkillModel>> get byCategory {
    final map = <String, List<SkillModel>>{};
    for (final s in skills) {
      map.putIfAbsent(s.category, () => []).add(s);
    }
    return map;
  }
}
