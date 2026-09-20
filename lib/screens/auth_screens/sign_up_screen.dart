import 'package:flutter/material.dart';
import '../../presentation/modules/auth/views/sign_up_view.dart';

export '../../presentation/modules/auth/views/sign_up_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpView();
  }
}
