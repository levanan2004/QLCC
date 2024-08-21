import 'package:apartment_management/Auth/google_login.dart';
import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/square_tile.dart';
import 'package:apartment_management/User/components/text_field.dart';
import 'package:apartment_management/Auth/forget_password_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? onTap;
  const LoginPage({super.key, this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Text Controller
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

  // người dùng đăng nhập
  void signIn() async {
    // Show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: Circular(),
            ));

    // try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailTextController.text.trim(),
          password: passwordTextController.text.trim());

      // pop loading circle
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      // ignore: use_build_context_synchronously
      Navigator.pop(context);

      //display error message
      displayMessage(e.code);
    }
  }

  // Display a dialog message
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(message),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 25,
                  ),
                  //welcome back message
                  Text(
                    "Chào mừng trở lại!\nRất vui khi thấy bạn!".tr(),
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Color(0xFF1E232C),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  MyTextFormField(
                      controller: emailTextController,
                      hintText: "Nhập email".tr(),
                      icon: Icon(Icons.email),
                      obscureText: false),
                  const SizedBox(
                    height: 25,
                  ),
                  MyTextFormField(
                      controller: passwordTextController,
                      hintText: "Nhập mật khẩu".tr(),
                      icon: Icon(Icons.lock),
                      obscureText: true),
                  const SizedBox(
                    height: 15,
                  ),
                  // GestureDetector ForgetPassword
                  _buildForgetPassword(),
                  const SizedBox(
                    height: 25,
                  ),
                  // Button Login
                  GestureDetector(
                    onTap: signIn,
                    child: MyButton(
                      text: "Đăng nhập".tr(),
                      color: Colors.black,
                      colorText: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  _buildGoogleButton(),
                  const SizedBox(
                    height: 25,
                  ),
                  // Row Don’t have an account? Register Now
                  _buildRegister()
                ],
              ),
            ),
          ),
        ));
  }

  Widget _buildForgetPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return const ForgetPassword();
            }));
          },
          child: Text(
            "Quên mật khẩu?".tr(),
            style: TextStyle(
                fontFamily: 'Urbanist',
                fontWeight: FontWeight.bold,
                color: Color(0xFF35C2C1)),
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleButton() {
    return Column(
      children: [
        // Or Continue With
        Row(
          children: [
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Hoặc đăng nhập với".tr(),
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: Color(0xFF6A707C),
                ),
              ),
            ),
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // Google + Phone sign in button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // google button
            SquareTile(
                imagePath: 'assets/icons/icon_google.png',
                onTap: () => AuthService().signInWithGoogle()),
            SizedBox(
              width: 10,
            ),
            SquareTile(
                imagePath: 'assets/icons/icon_phone.png',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Chức Năng Chưa Hoàn Thiện").tr(),
                        content: Text(
                                "Bạn vui lòng thử lại sau, chức năng hiện tại chưa hoàn thiện")
                            .tr(),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Đóng").tr(),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        )
      ],
    );
  }

  Widget _buildRegister() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Bạn không có tài khoản? ".tr(),
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              color: Color(0xFF1E232C),
            )),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            " Đăng ký ngay".tr(),
            style: TextStyle(
                fontFamily: 'Urbanist',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF35C2C1)),
          ),
        )
      ],
    );
  }
}
