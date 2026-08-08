import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/home',
        builder: (context, state) {
          return const Scaffold(
            body: Center(
              child: Text('Vision Companion'),
            ),
          );
        },
      ),
    ],
  );
}