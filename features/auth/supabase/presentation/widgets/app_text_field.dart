import 'package:flutter/material.dart';
import 'package:ticktask/shared/theme/colors.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;
  final String? errorText;
  final bool enabled;
  final String? hintText;
  final FocusNode? focusNode;
  final int maxLines;
  final bool autofocus;

  const AppTextField({
    Key? key,
    required this.label,
    this.controller,
    this.validator,
    this.onChanged,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
    this.errorText,
    this.enabled = true,
    this.hintText,
    this.focusNode,
    this.maxLines = 1,
    this.autofocus = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: AppColors.darkOnSurface,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          enabled: enabled,
          focusNode: focusNode,
          maxLines: maxLines,
          autofocus: autofocus,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.darkOnSurface,
          ),
          decoration: InputDecoration(
            prefixIcon: prefix,
            suffixIcon: suffix,
            errorText: errorText,
            hintText: hintText,
            hintStyle: TextStyle(
              color: AppColors.darkOnSurface.withOpacity(0.5),
              fontSize: 16,
            ),
            filled: true,
            fillColor: AppColors.darkSurfaceVariant,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.darkError,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.darkPrimary,
                width: 1,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
