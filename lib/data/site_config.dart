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
      role: 'Mobile App Developer',
      company: 'GM IT Solution',
      period: 'May 2025 – Present',
      points: [
        'Production Flutter apps with MVVM and Clean Architecture: HRLynx, ChatterBee, Hop Across America.',
        'REST auth, token handling, structured errors, FCM/APNs, and Stripe in-app payments.',
        'RevenueCat subscriptions and entitlements; CodeMagic CI/CD to App Store and Play Store.',
      ],
    ),
    SiteExperience(
      role: 'Jr Flutter Developer',
      company: 'Fleekbd',
      period: 'Nov 2024 – May 2025',
      points: [
        'WebSocket for real-time bidirectional data between app and server.',
        'Cut unnecessary widget rebuilds and used Dart isolates so heavy work stays off the UI thread.',
        'Figma to responsive Flutter UI, intl localization, and Flutter Secure Storage for encrypted local data.',
      ],
    ),
    SiteExperience(
      role: 'Flutter Intern',
      company: 'Universal Trade',
      period: 'Internship',
      points: [
        'Internship building Flutter screens and shipping location features with Google Maps.',
        'Client-ready UI, session handling, and day-to-day app reliability.',
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
