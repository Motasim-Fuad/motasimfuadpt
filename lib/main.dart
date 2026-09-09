import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_portfolio/bindings/app_binding.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/views/dashboard/dashboard_guard.dart';
import 'package:flutter_portfolio/views/dashboard/login_screen.dart';
import 'package:flutter_portfolio/views/portfolio/blog_article_page.dart';
import 'package:flutter_portfolio/utils/motion.dart';
import 'package:flutter_portfolio/views/portfolio/portfolio_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'firebase_options.dart';

void main() async {
  usePathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kIsWeb) {
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
      title: 'Motasim Fuad — Flutter Engineer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      initialBinding: AppBinding(),
      defaultTransition: Transition.fadeIn,
      customTransition: AppPageTransition(),
      transitionDuration: Motion.page,
      scrollBehavior: AppScrollBehavior(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => const PortfolioScreen()),
        GetPage(name: '/portfolio', page: () => const PortfolioScreen()),
        GetPage(name: '/notes/:id', page: () => const BlogArticlePage()),
        GetPage(
          name: '/login',
          page: () => Theme(
            data: AppTheme.dashboardTheme,
            child: const LoginScreen(),
          ),
        ),
        GetPage(
          name: '/dashboard',
          page: () => Theme(
            data: AppTheme.dashboardTheme,
            child: const DashboardGuard(),
          ),
        ),
      ],
    );
  }
}
