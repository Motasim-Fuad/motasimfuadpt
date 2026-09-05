import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final List<String> technologies;
  final String githubUrl;
  final String liveUrl;
  final String appStoreUrl;
  final String playStoreUrl;
  final bool featured;
  final int order;
  final DateTime createdAt;

  ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl = '',
    required this.technologies,
    this.githubUrl = '',
    this.liveUrl = '',
    this.appStoreUrl = '',
    this.playStoreUrl = '',
    this.featured = false,
    this.order = 0,
    required this.createdAt,
  });

  static bool looksLikeAppStore(String url) {
    final u = url.toLowerCase();
    return u.contains('apps.apple.com') || u.contains('itunes.apple.com');
  }

  static bool looksLikePlayStore(String url) {
    final u = url.toLowerCase();
    return u.contains('play.google.com') || u.contains('play.app.goo.gl');
  }

  static bool looksLikeGithub(String url) {
    return url.toLowerCase().contains('github.com');
  }

  factory ProjectModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final github = (data['githubUrl'] ?? '').toString();
    final live = (data['liveUrl'] ?? '').toString();
    var appStore = (data['appStoreUrl'] ?? '').toString();
    var playStore = (data['playStoreUrl'] ?? '').toString();

    if (appStore.isEmpty && looksLikeAppStore(github)) appStore = github;
    if (appStore.isEmpty && looksLikeAppStore(live)) appStore = live;
    if (playStore.isEmpty && looksLikePlayStore(live)) playStore = live;
    if (playStore.isEmpty && looksLikePlayStore(github)) playStore = github;

    return ProjectModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      technologies: List<String>.from(data['technologies'] ?? []),
      githubUrl: looksLikeGithub(github) ? github : '',
      liveUrl: (looksLikeAppStore(live) || looksLikePlayStore(live)) ? '' : live,
      appStoreUrl: appStore,
      playStoreUrl: playStore,
      featured: data['featured'] ?? false,
      order: data['order'] ?? 0,
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'description': description,
    'imageUrl': imageUrl,
    'technologies': technologies,
    'githubUrl': githubUrl,
    'liveUrl': liveUrl,
    'appStoreUrl': appStoreUrl,
    'playStoreUrl': playStoreUrl,
    'featured': featured,
    'order': order,
    'createdAt': Timestamp.fromDate(createdAt),
  };
}

class SkillModel {
  final String id;
  final String name;
  final String category;
  final int proficiency;
  final String iconName;

  SkillModel({
    required this.id,
    required this.name,
    required this.category,
    required this.proficiency,
    this.iconName = '',
  });

  factory SkillModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SkillModel(
      id: doc.id,
      name: data['name'] ?? '',
      category: data['category'] ?? 'Other',
      proficiency: data['proficiency'] ?? 50,
      iconName: data['iconName'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'category': category,
    'proficiency': proficiency,
    'iconName': iconName,
  };
}

class BlogModel {
  final String id;
  final String title;
  final String excerpt;
  final String content;
  final String imageUrl;
  final List<String> tags;
  final int readTimeMinutes;
  final DateTime publishedAt;
  final bool published;

  BlogModel({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    this.imageUrl = '',
    required this.tags,
    this.readTimeMinutes = 5,
    required this.publishedAt,
    this.published = true,
  });

  factory BlogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BlogModel(
      id: doc.id,
      title: data['title'] ?? '',
      excerpt: data['excerpt'] ?? '',
      content: data['content'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      readTimeMinutes: data['readTimeMinutes'] ?? 5,
      publishedAt: (data['publishedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      published: data['published'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'excerpt': excerpt,
    'content': content,
    'imageUrl': imageUrl,
    'tags': tags,
    'readTimeMinutes': readTimeMinutes,
    'publishedAt': Timestamp.fromDate(publishedAt),
    'published': published,
  };
}

class ContactModel {
  final String id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final bool read;
  final DateTime sentAt;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    this.read = false,
    required this.sentAt,
  });

  factory ContactModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ContactModel(
      id: doc.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      subject: data['subject'] ?? '',
      message: data['message'] ?? '',
      read: data['read'] ?? false,
      sentAt: (data['sentAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toFirestore() => {
    'name': name,
    'email': email,
    'subject': subject,
    'message': message,
    'read': read,
    'sentAt': Timestamp.fromDate(sentAt),
  };
}

class StatsModel {
  final int projectsCompleted;
  final int yearsExperience;
  final int happyClients;
  final int githubStars;

  StatsModel({
    this.projectsCompleted = 0,
    this.yearsExperience = 0,
    this.happyClients = 0,
    this.githubStars = 0,
  });

  factory StatsModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return StatsModel(
      projectsCompleted: data['projectsCompleted'] ?? 0,
      yearsExperience: data['yearsExperience'] ?? 0,
      happyClients: data['happyClients'] ?? 0,
      githubStars: data['githubStars'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() => {
    'projectsCompleted': projectsCompleted,
    'yearsExperience': yearsExperience,
    'happyClients': happyClients,
    'githubStars': githubStars,
  };
}