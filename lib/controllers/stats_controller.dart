import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class StatsController extends GetxController {
  static StatsController get to => Get.find();

  final _service = FirebaseService();
  final stats = StatsModel(
    projectsCompleted: 25,
    yearsExperience: 3,
    happyClients: 15,
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
      print('Stats updated: ${s.projectsCompleted} projects');
    }, onError: (e) {
      print('Stats stream error: $e');
      isLoading.value = false;
    });
    refreshDashCounts();
  }

  Future<void> refreshDashCounts() async {
    try {
      print('Refreshing dashboard counts...');
      final counts = await _service.getDashboardCounts();
      print('Dashboard counts received: $counts');
      dashCounts.value = counts;
    } catch (e) {
      print('Dashboard counts error: $e');
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