import 'package:get/get.dart';
import '../models/model.dart';
import '../services/firebase_services.dart';

class ContactController extends GetxController {
  static ContactController get to => Get.find();

  final _service = FirebaseService();
  final contacts = <ContactModel>[].obs;
  final isLoading = true.obs;
  final isSending = false.obs;
  final sent = false.obs;

  bool _listening = false;

  @override
  void onInit() {
    super.onInit();
    if (_service.isAdmin) {
      _loadContacts();
    } else {
      isLoading.value = false;
    }
  }

  void _loadContacts() {
    if (_listening) return;
    _listening = true;
    _service.streamContacts().listen((list) {
      contacts.value = list;
      isLoading.value = false;
    }, onError: (_) => isLoading.value = false);
  }

  void initAdminStream() {
    if (_service.isAdmin) {
      _loadContacts();
    }
  }

  Future<void> send(ContactModel contact) async {
    isSending.value = true;
    final ok = await _service.sendContact(contact);
    isSending.value = false;
    sent.value = ok;
  }

  Future<void> markRead(String id) => _service.markContactRead(id);
  Future<void> delete(String id) => _service.deleteContact(id);

  void resetSent() => sent.value = false;

  int get unreadCount => contacts.where((c) => !c.read).length;
}