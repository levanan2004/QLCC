import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SexTextForm extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Icon? icon;

  const SexTextForm({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // Hàm kiểm tra nhập vào 1 và 0
    String? genderValidator(String? value) {
      if (value != "1" && value != "0") {
        return "Vui lòng nhập '1' cho Nam hoặc '0' cho Nữ".tr();
      }
      return null;
    }

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
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
      validator: genderValidator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
    );
  }
}
