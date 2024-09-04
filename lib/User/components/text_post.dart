import 'package:flutter/material.dart';

class MyTextFieldPost extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final FocusNode? focusNode;
  final Function()? ontap;

  const MyTextFieldPost(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText,
      this.focusNode,
      this.ontap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        onTap: ontap,
        controller: controller,
        obscureText: obscureText,
        focusNode: focusNode,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide(color: Colors.white),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.blue),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.grey[200],
            filled: true,
            hintText: hintText,
            hintStyle: TextStyle(
              color: Colors.grey.shade500,
              fontFamily: "Urbanist",
            )),
      ),
    );
  }
}
