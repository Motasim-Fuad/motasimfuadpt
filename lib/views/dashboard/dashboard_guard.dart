import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/theme/app_theme.dart';
import 'package:flutter_portfolio/views/dashboard/dashboard_screen.dart';
import 'package:flutter_portfolio/views/dashboard/login_screen.dart';

class DashboardGuard extends StatelessWidget {
  const DashboardGuard({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: AppColors.dashBg,
            body: Center(
              child: CircularProgressIndicator(color: AppColors.rust),
            ),
          );
        }
        if (snapshot.data == null) {
          return const LoginScreen();
        }
        return const DashboardScreen();
      },
    );
  }
}
