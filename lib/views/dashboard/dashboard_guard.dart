import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/views/dashboard/dashboard_screen.dart';
import 'package:flutter_portfolio/views/dashboard/login_screen.dart';

class DashboardGuard extends StatelessWidget {
  const DashboardGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const LoginScreen();
    }
    return const DashboardScreen();
  }
}