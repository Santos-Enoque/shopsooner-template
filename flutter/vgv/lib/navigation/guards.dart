import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// A navigation guard that checks if a user is authenticated
class AuthGuard {
  /// Check if the user is authenticated
  /// Return null to allow navigation, or a redirect location if not allowed
  String? canNavigate(BuildContext context, GoRouterState state) {
    final isAuthenticated = false; // Replace with actual auth check

    if (!isAuthenticated) {
      return '/login'; // Redirect to login
    }

    return null; // Allow navigation
  }
}
