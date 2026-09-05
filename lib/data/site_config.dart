class SiteConfig {
  static const name = 'Md Motasim Fuad';
  static const shortName = 'Motasim Fuad';
  static const role = 'Flutter Engineer';
  static const location = 'Dhaka, Bangladesh';
  static const email = 'motasimfuad99@gmail.com';
  static const tagline =
      'I ship production Flutter apps — architecture first, payments and maps included.';
  static const bio =
      'Application developer for Android and iOS. Day job is Flutter: GetX, MVVM, Firebase, maps, and subscriptions. I can read a FastAPI + Postgres contract, follow Docker Compose, and talk Redis caching without pretending I own the backend.';
  static const aboutNote =
      'I am an app developer first. Python, FastAPI, PostgreSQL, Docker, and Redis are intermediate — I use them to understand the API I consume, and I can grow into fuller stack work with a backend lead in the room.';

  static const cvUrl =
      'https://drive.google.com/file/d/1Q76vtFLJd29LyYNz0iTLOh04Pa6vswCR/view?usp=drive_link';
  static const githubUrl = 'https://github.com/Motasim-Fuad';
  static const linkedInUrl =
      'https://www.linkedin.com/in/motasim-fuad-27949b319/';
  static const leetCodeUrl = 'https://leetcode.com/u/Motasim_Fuad/';
  static const mailUrl =
      'https://mail.google.com/mail/?view=cm&fs=1&to=$email';

  static const experience = [
    SiteExperience(
      role: 'Application Developer',
      company: 'Sparktech Agency',
      period: 'Current',
      points: [
        'Shipped store apps with GetX and MVVM: HRLynx, ChatterBee, Hop Across America.',
        'REST authentication, role-based flows, and Firebase (OTP, FCM, realtime).',
        'In-app purchases, subscription trials, and RevenueCat purchase validation.',
      ],
    ),
    SiteExperience(
      role: 'Mobile Application Developer',
      company: 'Universal Technology Corporation',
      period: 'Previous',
      points: [
        'Shipped location features with Google Maps and careful permission handling.',
        'Worked on client-ready UI, session handling, and app reliability.',
      ],
    ),
  ];
}

class SiteExperience {
  final String role;
  final String company;
  final String period;
  final List<String> points;

  const SiteExperience({
    required this.role,
    required this.company,
    required this.period,
    required this.points,
  });
}
