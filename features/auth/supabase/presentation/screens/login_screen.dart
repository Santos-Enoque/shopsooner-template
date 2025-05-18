import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:ticktask/navigation/routes.dart';
import 'package:ticktask/shared/theme/colors.dart';
import 'package:toastification/toastification.dart';
import 'package:ticktask/features/auth/domain/models/models.dart';
import 'package:ticktask/features/auth/presentation/blocs/auth/auth_barrel.dart';
import 'package:ticktask/features/auth/presentation/blocs/login/login_barrel.dart';
import 'package:ticktask/features/auth/presentation/widgets/app_button.dart';
import 'package:ticktask/features/auth/presentation/widgets/app_text_field.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authBloc: context.read<AuthBloc>(),
      ),
      child: Scaffold(
        backgroundColor: AppColors.darkBackground,
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  // Navigate directly to home on successful login
                  context.go(AppRoutes.home);
                } else if (state.status == AuthStatus.failure) {
                  // The LoginBloc already listens for auth failures
                }
              },
            ),
            BlocListener<LoginBloc, LoginState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status.isFailure) {
                  String errorMessage = 'Unable to sign in. Please try again.';

                  // Extract the actual error message from the exception
                  if (state.errorMessage != null) {
                    if (state.errorMessage!
                        .contains('Invalid login credentials')) {
                      errorMessage =
                          'Invalid email or password. Please try again.';
                    } else if (state.errorMessage!
                        .contains('internet connection')) {
                      errorMessage =
                          'No internet connection. Please check your network settings and try again.';
                    } else if (state.errorMessage!
                        .contains('email not confirmed')) {
                      errorMessage =
                          'Please verify your email before signing in.';
                    } else {
                      // Extract the message from the AuthException
                      final match = RegExp(r'message: ([^,]+)')
                          .firstMatch(state.errorMessage!);
                      if (match != null) {
                        errorMessage = match.group(1) ?? errorMessage;
                      }
                    }
                  }

                  _showAuthDialog(
                    context: context,
                    title: 'Sign In Failed',
                    message: errorMessage,
                    isError: true,
                    isNetworkError:
                        state.errorMessage?.contains('internet connection') ??
                            false,
                  );
                }
              },
            ),
          ],
          child: const SafeArea(
            child: LoginForm(),
          ),
        ),
      ),
    );
  }

  void _showAuthDialog({
    required BuildContext context,
    required String title,
    required String message,
    required bool isError,
    bool isNetworkError = false,
    VoidCallback? onClose,
  }) {
    if (isError) {
      toastification.show(
        context: context,
        type: ToastificationType.error,
        style: ToastificationStyle.fillColored,
        title: Text(title),
        description: Text(message),
        alignment: Alignment.topRight,
        autoCloseDuration: const Duration(seconds: 5),
        showProgressBar: true,
      );

      if (isNetworkError) {
        // Show network settings dialog after a short delay
        Future.delayed(const Duration(seconds: 1), () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Network Issue'),
              content: const Text(
                'Please check your internet connection and try again.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        });
      }
    } else {
      toastification.show(
        context: context,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        title: Text(title),
        description: Text(message),
        alignment: Alignment.topRight,
        autoCloseDuration: const Duration(seconds: 3),
        showProgressBar: true,
      );

      if (onClose != null) {
        Future.delayed(const Duration(seconds: 3), () {
          onClose();
        });
      }
    }
  }
}

class LoginForm extends StatelessWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // App logo or icon
              const Center(
                child: Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: AppColors.darkPrimary,
                ),
              ),
              const SizedBox(height: 40),
              // Title
              const Text(
                'Welcome back',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkOnSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.darkOnSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 48),
              // Email field
              _EmailInput(),
              const SizedBox(height: 16),
              // Password field
              _PasswordInput(),
              const SizedBox(height: 8),
              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Navigate to forgot password
                  },
                  child: const Text(
                    'Forgot password?',
                    style: TextStyle(
                      color: AppColors.darkPrimary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Login button
              _LoginButton(),
              const SizedBox(height: 16),
              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Don\'t have an account?',
                    style: TextStyle(
                      color: AppColors.darkOnSurface.withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to register using GoRouter
                      context.go(AppRoutes.register);
                    },
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: AppColors.darkPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextField(
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) {
            context.read<LoginBloc>().add(LoginEmailChanged(email));
          },
          errorText: state.email.displayError != null
              ? Email.showEmailErrorMessage(state.email.error)
              : null,
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AppTextField(
          label: 'Password',
          hintText: 'Enter your password',
          obscureText: true,
          onChanged: (password) {
            context.read<LoginBloc>().add(LoginPasswordChanged(password));
          },
          errorText: state.password.displayError != null
              ? Password.showPasswordErrorMessage(state.password.error)
              : null,
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return AppButton(
          text: 'Sign In',
          isLoading: state.status.isInProgress,
          onPressed: state.isValid
              ? () {
                  context.read<LoginBloc>().add(LoginSubmitted());
                }
              : () {
                  // Auto-validate on submit attempt
                  context.read<LoginBloc>().add(LoginSubmitted());
                },
        );
      },
    );
  }
}
