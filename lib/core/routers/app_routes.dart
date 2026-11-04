import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'app_router_name.dart';

class AppRoutes {
  AppRoutes._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRouterName.splash,
    routes: [
      GoRoute(
        path: AppRouterName.splash,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text(
              'Eureka',
              style: TextStyle(fontFamily: 'Tajawal', fontSize: 24),
            ),
          ),
        ),
      ),
    ],
  );
}

