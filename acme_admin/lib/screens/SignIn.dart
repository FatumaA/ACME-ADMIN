import 'package:acme_admin/state/auth.dart';
import 'package:acme_admin/widgets/AuthForm.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: AuthForm());
  }
}
// flutter run -d chrome --web-port=3000