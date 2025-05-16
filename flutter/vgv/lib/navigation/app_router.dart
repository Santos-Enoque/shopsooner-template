import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:vgv/features/counter/view/counter_page.dart';
import 'package:vgv/navigation/routes.dart';

/// Application router configuration
final appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: [
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => const CounterPage(),
    ),
  ],
);
