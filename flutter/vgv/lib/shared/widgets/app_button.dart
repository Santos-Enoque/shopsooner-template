import 'package:flutter/material.dart';

/// Button variants
enum ButtonVariant {
  /// Primary button
  primary,

  /// Secondary button
  secondary,

  /// Outlined button
  outlined,

  /// Text-only button
  text,
}

/// A consistent button widget for the application
class AppButton extends StatelessWidget {
  /// Creates a new app button
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.icon,
    this.isLoading = false,
    this.fullWidth = false,
    this.disabled = false,
    super.key,
  });

  /// Button text
  final String label;

  /// Callback when the button is pressed
  final VoidCallback onPressed;

  /// Button variant style
  final ButtonVariant variant;

  /// Optional icon to display
  final IconData? icon;

  /// Whether the button is in loading state
  final bool isLoading;

  /// Whether the button should take full width
  final bool fullWidth;

  /// Whether the button is disabled
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Configure button based on variant
    switch (variant) {
      case ButtonVariant.primary:
        return _buildElevatedButton(theme);
      case ButtonVariant.secondary:
        return _buildSecondaryButton(theme);
      case ButtonVariant.outlined:
        return _buildOutlinedButton(theme);
      case ButtonVariant.text:
        return _buildTextButton(theme);
    }
  }

  Widget _buildElevatedButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: disabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: fullWidth ? const Size(double.infinity, 48) : null,
      ),
      child: _buildButtonContent(theme),
    );
  }

  Widget _buildSecondaryButton(ThemeData theme) {
    return ElevatedButton(
      onPressed: disabled || isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: fullWidth ? const Size(double.infinity, 48) : null,
        backgroundColor: theme.colorScheme.secondary,
        foregroundColor: theme.colorScheme.onSecondary,
      ),
      child: _buildButtonContent(theme),
    );
  }

  Widget _buildOutlinedButton(ThemeData theme) {
    return OutlinedButton(
      onPressed: disabled || isLoading ? null : onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: fullWidth ? const Size(double.infinity, 48) : null,
      ),
      child: _buildButtonContent(theme),
    );
  }

  Widget _buildTextButton(ThemeData theme) {
    return TextButton(
      onPressed: disabled || isLoading ? null : onPressed,
      style: TextButton.styleFrom(
        minimumSize: fullWidth ? const Size(double.infinity, 48) : null,
      ),
      child: _buildButtonContent(theme),
    );
  }

  Widget _buildButtonContent(ThemeData theme) {
    if (isLoading) {
      return const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label),
        ],
      );
    }

    return Text(label);
  }
}
