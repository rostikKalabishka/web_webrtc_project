import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.hintText,
    required this.keyboardType,
    this.suffixIcon,
    this.prefixIcon,
    this.focusNode,
    this.errorMsg,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final bool obscureText;
  final String? hintText;
  final TextInputType keyboardType;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final FocusNode? focusNode;
  final String? errorMsg;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      validator: validator,
      style: theme.inputDecorationTheme.hintStyle,
      // onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
          errorText: errorMsg,
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: theme.inputDecorationTheme.border!.borderSide.color),
          ),
          disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: theme.inputDecorationTheme.border!.borderSide.color)),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                  color: theme.inputDecorationTheme.border!.borderSide.color))),
      controller: controller,
    );
  }
}
