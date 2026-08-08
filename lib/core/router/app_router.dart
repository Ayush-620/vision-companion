import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';

import '../../features/home/pages/home_page.dart';
import '../../features/auth/pages/login_page.dart';
import '../../features/auth/pages/signup_page.dart';
import '../../features/detector/pages/detector_page.dart';

class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier() {
    _subscription = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

final authChangeNotifier = AuthChangeNotifier();

final GoRouter appRouter = GoRouter(
  initialLocation: '/home',

  refreshListenable: authChangeNotifier,

  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;

    final isLoggedIn = user != null;

    final isAuthPage =
        state.matchedLocation == '/login' ||
        state.matchedLocation == '/signup';

    if (!isLoggedIn && !isAuthPage) {
      return '/login';
    }

    if (isLoggedIn && isAuthPage) {
      return '/home';
    }

    return null;
  },

  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (context, state) => const SignupPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
  path: '/detector',
  builder: (context, state) => const DetectorPage(),
  ),
  ],
);