import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class StatsController extends GetxController {
  static StatsController get to => Get.find();

  final _service = FirebaseService();
  final stats = StatsModel(
    projectsCompleted: 25,
    yearsExperience: 3,
    deliveryOnTime: 96,
    githubStars: 120,
  ).obs;
  final dashCounts = <String, int>{}.obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _service.streamStats().listen((s) {
      stats.value = s;
      isLoading.value = false;
    }, onError: (_) {
      isLoading.value = false;
    });
    refreshDashCounts();
  }

  Future<void> refreshDashCounts() async {
    try {
      final counts = await _service.getDashboardCounts();
      dashCounts.value = counts;
    } catch (e) {
      // Fallback data
      dashCounts.value = {
        'projects': 0,
        'skills': 0,
        'blogs': 0,
        'unreadMessages': 0,
      };
    }
  }

  Future<void> updateStats(StatsModel s) => _service.updateStats(s);
}