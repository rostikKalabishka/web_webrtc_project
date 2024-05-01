import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.onChanged,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final Function(String?)? onChanged;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      style: theme.inputDecorationTheme.hintStyle,
      // onChanged: onChanged,
      obscureText: obscureText,
      decoration: InputDecoration(
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
