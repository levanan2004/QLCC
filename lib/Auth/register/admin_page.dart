import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/email_textformf.dart';
import 'package:apartment_management/User/components/password_textformfield.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:apartment_management/Auth/forget_password_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminRegisterPage extends StatefulWidget {
  final Function()? onTap;
  const AdminRegisterPage({super.key, this.onTap});

  @override
  State<AdminRegisterPage> createState() => _AdminRegisterPageState();
}

class _AdminRegisterPageState extends State<AdminRegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key
  // Text Controller
  final userNameTextController = TextEditingController();
  final emailTextController = TextEditingController();

  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  // Đăng ký tài khoản người dùng
  Future<void> signUp() async {
    // make sure passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      // pop loading circle
      widget.onTap;

      // show error to user
      displayMessage("Mật khẩu không trùng nhau".tr());
      return;
    }

    // try creating the user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailTextController.text.trim(),
              password: passwordTextController.text.trim());
      // after creating the user, create a new document in cloud firestore called Users
      DocumentReference userDocRef = FirebaseFirestore.instance
          .collection('Users')
          .doc(userCredential.user!.email);

      await userDocRef.set({
        'email': emailTextController.text.trim(),
        'username': userNameTextController.text.trim(),
        'idApartmentBuilding': "a",
        'idApartmentFloor': "a",
        'idApartment': "a",
        'idApartmentName': 999,
        'role': "1",
        'Sex': "1",
        'CODE': '1321dqw'
      });
      await userDocRef.collection('CODE').add({'ApartmentBuildingCode': '1'});

      // pop loading circle
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
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
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    RequiredTextForm(
                        maxLine: 20,
                        controller: userNameTextController,
                        hintText: "Tên Người dùng".tr(),
                        icon: Icon(Icons.person),
                        obscureText: false),
                    EmailTextForm(
                        controller: emailTextController,
                        hintText: "Email".tr(),
                        icon: Icon(Icons.email),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    PasswordTextForm(
                        controller: passwordTextController,
                        hintText: "Mật khẩu".tr(),
                        icon: Icon(Icons.lock),
                        obscureText: true),
                    PasswordTextForm(
                        controller: confirmPasswordTextController,
                        hintText: "Nhập lại mật khẩu".tr(),
                        icon: Icon(Icons.lock_reset_sharp),
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
                      onTap: signUp,
                      child: MyButton(
                        text: "Đăng ký".tr(),
                        color: Colors.black,
                        colorText: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Row Don’t have an account? Register Now
                    _buildLogin(),
                    const SizedBox(
                      height: 50,
                    ),
                  ],
                ),
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

  Widget _buildLogin() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Bạn đã có tài khoản? ".tr(),
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              color: Color(0xFF1E232C),
            )),
        GestureDetector(
          onTap: widget.onTap,
          child: Text(
            " Đăng nhập, ngay!".tr(),
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
