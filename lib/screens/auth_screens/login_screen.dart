import 'package:flutter/material.dart';
import '../../presentation/modules/auth/views/login_view.dart';

export '../../presentation/modules/auth/views/login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginView();
  }
}
