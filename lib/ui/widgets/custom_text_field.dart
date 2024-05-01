import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    //required this.onChanged,
  });

  final TextEditingController controller;
  // final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // onChanged: onChanged,
      decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
          )),
      controller: controller,
    );
  }
}
