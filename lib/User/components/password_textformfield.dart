import 'package:flutter/material.dart';

class PasswordTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;
  final bool? requireLeadingZero;

  const PasswordTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon,
    this.requireLeadingZero,
  });

  @override
  Widget build(BuildContext context) {
    String? customValidator(String? value) {
      if (value == null || value.isEmpty) {
        return 'Trường này là bắt buộc';
      }
      return null;
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLength: 30,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        fillColor: Colors.grey[200],
        filled: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Urbanist',
          color: Colors.grey[500],
        ),
        prefixIcon: icon,
      ),
      validator: (value) => customValidator(value),
    );
  }
}
