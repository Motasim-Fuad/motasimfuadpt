import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class ProjectController extends GetxController {
  static ProjectController get to => Get.find();

  final _service = FirebaseService();
  final projects = <ProjectModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _service.streamProjects().listen((list) {
      projects.value = list;
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);
  }

  Future<void> add(ProjectModel project) async {
    await _service.addProject(project);
  }

  Future<void> updateProject(ProjectModel project) async {
    await _service.updateProject(project);
  }

  Future<void> delete(String id) async {
    await _service.deleteProject(id);
  }
}