import 'package:flutter/material.dart';
import 'package:acme_admin/screens/BasePage.dart';
import 'package:acme_admin/screens/SignIn.dart';
import 'package:acme_admin/state/auth.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

final authState = AuthStateLocal();

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  debugLogDiagnostics: true,
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const SignIn();
      },
    ),
    GoRoute(
      path: '/dashboard',
      builder: (BuildContext context, GoRouterState state) {
        return const BasePage();
      },
    ),
  ],
  redirect: (context, state) {
    final bool loggedIn = context.watch<AuthStateLocal>().loggedIn;
    print('loggedIn from router: $loggedIn');
    if (!loggedIn) {
      return '/';
    }
    if (loggedIn) {
      return '/dashboard';
    }
    return null;
  },
);
