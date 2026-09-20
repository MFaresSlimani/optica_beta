import 'package:flutter/material.dart';
import 'core/network/supabase_client.dart';
import 'screens/auth_screens/login_screen.dart';
import 'screens/home_screen/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final session = supabaseClient.auth.currentSession;
    if (session == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}
