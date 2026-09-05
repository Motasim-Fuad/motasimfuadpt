import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import '../models/model.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;

  FirebaseService._internal() {
    if (kIsWeb) {
      // Web-এ persistence বন্ধ - শুধু এটুকুই যথেষ্ট
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: false,
      );
    }
  }

  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // ─── AUTH ───────────────────────────────────
  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      return null;
    }
  }

  Future<void> signOut() => _auth.signOut();
  User? get currentUser => _auth.currentUser;
  bool get isAdmin => _auth.currentUser != null;

  // ─── PROJECTS ───────────────────────────────
  Stream<List<ProjectModel>> streamProjects() {
    return _db
        .collection('projects')
        .orderBy('order')
        .snapshots()
        .map((s) => s.docs.map(ProjectModel.fromFirestore).toList());
  }

  Future<void> addProject(ProjectModel project) async {
    await _db.collection('projects').add(project.toFirestore());
  }

  Future<void> updateProject(ProjectModel project) async {
    await _db
        .collection('projects')
        .doc(project.id)
        .update(project.toFirestore());
  }

  Future<void> deleteProject(String id) async {
    await _db.collection('projects').doc(id).delete();
  }

  // ─── SKILLS ─────────────────────────────────
  Stream<List<SkillModel>> streamSkills() {
    return _db.collection('skills').snapshots().map(
            (s) => s.docs.map(SkillModel.fromFirestore).toList()
          ..sort((a, b) => b.proficiency.compareTo(a.proficiency)));
  }

  Future<void> addSkill(SkillModel skill) async {
    await _db.collection('skills').add(skill.toFirestore());
  }

  Future<void> updateSkill(SkillModel skill) async {
    await _db
        .collection('skills')
        .doc(skill.id)
        .update(skill.toFirestore());
  }

  Future<void> deleteSkill(String id) async {
    await _db.collection('skills').doc(id).delete();
  }

  // ─── BLOGS ──────────────────────────────────

  Stream<List<BlogModel>> streamBlogs({bool publishedOnly = true}) {
    try {
      Query query = _db.collection('blogs');

      // প্রথমে published filter প্রয়োগ করুন
      if (publishedOnly) {
        query = query.where('published', isEqualTo: true);
      }

      // তারপর orderBy দিন
      query = query.orderBy('publishedAt', descending: true);

      return query.snapshots().map((s) {
        final blogs = s.docs.map(BlogModel.fromFirestore).toList();
        print('✅ Blogs fetched: ${blogs.length} blogs');
        return blogs;
      }).handleError((error) {
        print('❌ Blogs stream error: $error');
        return <BlogModel>[];
      });
    } catch (e) {
      print('❌ Blogs stream exception: $e');
      return Stream.value([]);
    }
  }

  Future<void> addBlog(BlogModel blog) async {
    await _db.collection('blogs').add(blog.toFirestore());
  }

  Future<void> updateBlog(BlogModel blog) async {
    await _db.collection('blogs').doc(blog.id).update(blog.toFirestore());
  }

  Future<void> deleteBlog(String id) async {
    await _db.collection('blogs').doc(id).delete();
  }

  // ─── CONTACT ────────────────────────────────
  Future<bool> sendContact(ContactModel contact) async {
    try {
      await _db.collection('contacts').add(contact.toFirestore());
      return true;
    } catch (e) {
      return false;
    }
  }

  Stream<List<ContactModel>> streamContacts() {
    return _db
        .collection('contacts')
        .orderBy('sentAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map(ContactModel.fromFirestore).toList());
  }

  Future<void> markContactRead(String id) async {
    await _db.collection('contacts').doc(id).update({'read': true});
  }

  Future<void> deleteContact(String id) async {
    await _db.collection('contacts').doc(id).delete();
  }

  // ─── STATS ──────────────────────────────────
  Stream<StatsModel> streamStats() {
    return _db
        .collection('meta')
        .doc('stats')
        .snapshots()
        .map((doc) => doc.exists
        ? StatsModel.fromFirestore(doc)
        : StatsModel(
      projectsCompleted: 25,
      yearsExperience: 3,
      happyClients: 15,
      githubStars: 120,
    ));
  }

  Future<void> updateStats(StatsModel stats) async {
    await _db
        .collection('meta')
        .doc('stats')
        .set(stats.toFirestore(), SetOptions(merge: true));
  }

  Stream<String> streamProfileImageUrl() {
    return _db.collection('meta').doc('profile').snapshots().map((doc) {
      if (!doc.exists) return '';
      return (doc.data()?['imageUrl'] ?? '').toString();
    });
  }

  Future<void> setProfileImageUrl(String url) {
    return _db.collection('meta').doc('profile').set(
      {'imageUrl': url},
      SetOptions(merge: true),
    );
  }

  Future<String> uploadImageBytes({
    required Uint8List bytes,
    required String storagePath,
    String contentType = 'image/jpeg',
  }) async {
    final ref = FirebaseStorage.instance.ref(storagePath);
    await ref.putData(
      bytes,
      SettableMetadata(contentType: contentType),
    );
    return ref.getDownloadURL();
  }

  // ─── DASHBOARD OVERVIEW ─────────────────────
  Future<Map<String, int>> getDashboardCounts() async {
    final results = await Future.wait([
      _db.collection('projects').count().get(),
      _db.collection('skills').count().get(),
      _db.collection('blogs').where('published', isEqualTo: true).count().get(),
      _db.collection('contacts').where('read', isEqualTo: false).count().get(),
    ]);
    return {
      'projects': results[0].count ?? 0,
      'skills': results[1].count ?? 0,
      'blogs': results[2].count ?? 0,
      'unreadMessages': results[3].count ?? 0,
    };
  }
}