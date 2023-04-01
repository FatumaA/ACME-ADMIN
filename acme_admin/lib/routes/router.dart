import 'package:acme_admin/screens/Dashboard.dart';
import 'package:acme_admin/screens/SignInScreen.dart';
import 'package:acme_admin/screens/SignUpScreen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SignIn();
      },
    ),
    GoRoute(
      path: '/sign_up',
      builder: (BuildContext context, GoRouterState state) {
        return const SignUp();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return const Dashboard();
      },
    ),
  ],
);
