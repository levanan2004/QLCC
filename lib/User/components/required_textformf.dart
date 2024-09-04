import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class RequiredTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final int? maxLine;
  final Icon? icon;
  final bool? requireLeadingZero;

  const RequiredTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon,
    this.requireLeadingZero,
    required this.maxLine,
  });

  @override
  Widget build(BuildContext context) {
    String? customValidator(String? value, {bool? requireLeadingZero}) {
      if (value == null || value.isEmpty) {
        return "Trường này là bắt buộc".tr();
      }
      if (requireLeadingZero == false && value.startsWith('0')) {
        return "Ký tự đầu tiên không được là số 0".tr();
      }
      return null;
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      maxLength: maxLine,
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
      validator: (value) =>
          customValidator(value, requireLeadingZero: requireLeadingZero),
    );
  }
}
