import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_portfolio/dashboad.dart';
import 'package:flutter_portfolio/portfolio_screen.dart';
import 'package:get/get.dart';
import 'app_theme.dart';
import 'dashboard_guard.dart';
import 'firebase_options.dart';
import 'login_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
    await FirebaseFirestore.instance.clearPersistence();
    FirebaseFirestore.instance.settings = const Settings(
      persistenceEnabled: false,
    );
  }
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatelessWidget {
  const PortfolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Motasim Fuad',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialRoute: '/',          // এটা add করো
      getPages: [                 // routes এর বদলে getPages দাও
        GetPage(name: '/', page: () => const PortfolioScreen()),
        GetPage(name: '/portfolio', page: () => const PortfolioScreen()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardGuard()),
      ],
    );
  }
}