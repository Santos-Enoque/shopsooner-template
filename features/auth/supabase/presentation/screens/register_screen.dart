import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';
import 'package:toastification/toastification.dart';
import 'package:vgv/navigation/routes.dart';
import 'package:vgv/shared/theme/colors.dart';
import 'package:vgv/features/auth/domain/models/models.dart';
import 'package:vgv/features/auth/presentation/blocs/auth/auth_barrel.dart';
import 'package:vgv/features/auth/presentation/blocs/register/register_barrel.dart';
import 'package:vgv/features/auth/presentation/widgets/app_button.dart';
import 'package:vgv/features/auth/presentation/widgets/app_text_field.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

  const RegisterScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(
        authBloc: context.read<AuthBloc>(),
      ),
      child: Scaffold(
        body: MultiBlocListener(
          listeners: [
            BlocListener<AuthBloc, AuthState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status == AuthStatus.authenticated) {
                  // Navigate directly to home on successful registration
                  context.go(AppRoutes.home);
                } else if (state.status == AuthStatus.failure) {
                  // The RegisterBloc already listens for auth failures
                }
              },
            ),
            BlocListener<RegisterBloc, RegisterState>(
              listenWhen: (previous, current) =>
                  previous.status != current.status,
              listener: (context, state) {
                if (state.status.isFailure) {
                  String errorMessage =
                      'Unable to create account. Please try again.';

                  _showAuthDialog(
                    context: context,
                    title: 'Account Creation Failed',
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
            child: RegisterForm(),
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
        // No longer show AlertDialog for network issues; only show toast notification
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

class RegisterForm extends StatelessWidget {
  const RegisterForm({Key? key}) : super(key: key);

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
              Center(
                child: Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              const SizedBox(height: 40),
              // Title
              Text(
                'Create account',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                style: TextStyle(
                  fontSize: 16,
                  color:
                      Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 48),
              // Name field
              _NameInput(),
              const SizedBox(height: 16),
              // Email field
              _EmailInput(),
              const SizedBox(height: 16),
              // Password field
              _PasswordInput(),
              const SizedBox(height: 32),
              // Register button
              _RegisterButton(),
              const SizedBox(height: 16),
              // Login link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account?',
                    style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Navigate to login using GoRouter
                      context.go(AppRoutes.login);
                    },
                    child: Text(
                      'Sign in',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
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

class _NameInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.name != current.name,
      builder: (context, state) {
        return AppTextField(
          label: 'Full Name',
          hintText: 'Enter your name',
          keyboardType: TextInputType.name,
          onChanged: (name) {
            context.read<RegisterBloc>().add(RegisterNameChanged(name));
          },
          errorText: state.name.displayError != null
              ? Name.showNameErrorMessage(state.name.error)
              : null,
        );
      },
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return AppTextField(
          label: 'Email',
          hintText: 'Enter your email',
          keyboardType: TextInputType.emailAddress,
          onChanged: (email) {
            context.read<RegisterBloc>().add(RegisterEmailChanged(email));
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
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return AppTextField(
          label: 'Password',
          hintText: 'Create a password',
          obscureText: true,
          onChanged: (password) {
            context.read<RegisterBloc>().add(RegisterPasswordChanged(password));
          },
          errorText: state.password.displayError != null
              ? Password.showPasswordErrorMessage(state.password.error)
              : null,
        );
      },
    );
  }
}

class _RegisterButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterBloc, RegisterState>(
      buildWhen: (previous, current) =>
          previous.status != current.status ||
          previous.isValid != current.isValid,
      builder: (context, state) {
        return AppButton(
          text: 'Create Account',
          isLoading: state.status.isInProgress,
          onPressed: state.isValid
              ? () {
                  context.read<RegisterBloc>().add(RegisterSubmitted());
                }
              : () {
                  // Auto-validate on submit attempt
                  context.read<RegisterBloc>().add(RegisterSubmitted());
                },
        );
      },
    );
  }
}
