import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tictask/features/auth/presentation/blocs/auth/auth_barrel.dart';
import 'package:ticktask/shared/theme/colors.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  const AuthScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          // Navigate to main app when authenticated
          // Will be handled by the router
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.darkBackground,
          body: const Center(
            child: CircularProgressIndicator(
              color: AppColors.darkPrimary,
            ),
          ),
        );
      },
    );
  }
}
