import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class BlogController extends GetxController {
  static BlogController get to => Get.find();

  final _service = FirebaseService();
  final blogs = <BlogModel>[].obs;
  final allBlogs = <BlogModel>[].obs;
  final isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _service.streamBlogs(publishedOnly: false).listen((list) {
      allBlogs.value = list;
      blogs.value = list.where((b) => b.published).toList();
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);
  }

  Future<void> add(BlogModel blog) async {
    await _service.addBlog(blog);
  }

  Future<void> updateBlog(BlogModel blog) async {
    await _service.updateBlog(blog);
  }

  Future<void> delete(String id) async {
    await _service.deleteBlog(id);
  }
}
