import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vgv/features/counter/view/counter_page.dart';
import 'package:vgv/navigation/routes.dart';
import 'package:vgv/shared/screens/splash_screen.dart';

/// Application router configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (BuildContext context, GoRouterState state) {
    // If we're on the splash screen, stay there
    if (state.matchedLocation == AppRoutes.splash) {
      return null;
    }

    // If we're not on the splash screen, allow navigation
    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const CounterPage(),
    ),
  ],
);
