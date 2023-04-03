import 'package:acme_admin/screens/Dashboard.dart';
import 'package:acme_admin/screens/SignIn.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final authState = AuthStateLocal();

final GoRouter router = GoRouter(
  refreshListenable: AuthStateLocal(),
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SignIn();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return Dashboard();
      },
    ),
  ],
  redirect: (context, state) {
    final bool loggedIn = context.watch<AuthStateLocal>().loggedIn;
    print('loggedIn from router: $loggedIn');
    if (!loggedIn) return '/';
    if (loggedIn) return '/dashboard';

    return null;
  },
);
