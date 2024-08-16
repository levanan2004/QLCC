import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/dialog_success.dart';
import 'package:apartment_management/User/components/text_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  // Text Controller
  final emailTextController = TextEditingController();

  void dispose() {
    emailTextController.dispose();
    super.dispose();
  }

  Future passwordReset() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailTextController.text);
      showDialog(
          context: context,
          builder: (context) {
            return MyCustomDialog();
          });
    } on FirebaseAuthException catch (e) {
      print(e);
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text(e.message.toString()),
            );
          });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 52, 52, 52)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    height: 40,
                    child: Image.asset(
                      'assets/icons/icon_arrow.png',
                    ),
                  )),
              const SizedBox(
                height: 25,
              ),
              //welcome back message
              Text(
                "Quên mật khẩu!",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: Color(0xFF1E232C),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                  "Đừng lo lắng! Nó xảy ra. Vui lòng nhập địa chỉ email được liên kết với tài khoản của bạn.",
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: Color(0xFF8391A1),
                    fontSize: 16,
                  )),
              const SizedBox(
                height: 25,
              ),
              MyTextFormField(
                  controller: emailTextController,
                  hintText: "Nhập Email",
                  icon: Icon(Icons.email),
                  obscureText: false),
              const SizedBox(
                height: 25,
              ),
              GestureDetector(
                onTap: passwordReset,
                child: MyButton(
                  text: "Nộp",
                  color: Colors.black,
                  colorText: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
