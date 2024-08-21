import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddViolatePage extends StatefulWidget {
  final String violateCODE;
  final String violateEmail;
  const AddViolatePage({
    super.key,
    required this.violateCODE,
    required this.violateEmail,
  });

  @override
  State<AddViolatePage> createState() => _AddViolatePageState();
}

class _AddViolatePageState extends State<AddViolatePage> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Text Controller
  final titleController = TextEditingController();
  final contentController = TextEditingController();
  final finedController = TextEditingController();
  void addViolate() async {
    if (_formKey.currentState!.validate()) {
      if (titleController.text.isNotEmpty ||
          contentController.text.isNotEmpty ||
          finedController.text.isNotEmpty) {
        FirebaseFirestore.instance.collection('Violate').add({
          'Title': titleController.text.trim(),
          'Content': contentController.text.trim(),
          'Fined': finedController.text.trim(),
          'CODE': widget.violateCODE,
          'Email': widget.violateEmail,
          'StatusHandle': false,
          'TimeStamp': Timestamp.now()
        });
        FirebaseFirestore.instance.collection('Notifications').add({
          'Title': 'Bạn đã vi phạm 1 lỗi',
          'Content':
              'Hãy vào xem chi tiết ${titleController.text.trim()}, bạn đã bị Quản lý thêm 1 lỗi',
          'UserEmail': widget.violateEmail,
          'Status': false,
          'Timestamp': Timestamp.now(),
        });
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Nhập Không Đầy Đủ").tr(),
              content: Text("Xin vui lòng hãy nhập đủ 3 ô").tr(),
              actions: [
                TextButton(
                  child: Text("Đóng").tr(),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    }
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
                    SizedBox(
                      height: 20,
                    ),
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
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
                    RichText(
                      text: TextSpan(
                        text: "Người thuê ".tr(),
                        style: TextStyle(
                            fontSize: 30.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Urbanist"),
                        children: <TextSpan>[
                          TextSpan(
                            text: widget.violateEmail,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                                fontSize: 30.0,
                                fontFamily: "Urbanist"),
                          ),
                          TextSpan(
                            text: "\nvi phạm nội quy".tr(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Urbanist"),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(
                      height: 30,
                    ),
                    // Tên Tòa Nhà Chung Cư
                    RequiredTextForm(
                      controller: titleController,
                      hintText: "Tiêu đề lỗi".tr(),
                      icon: Icon(Icons.label_outline),
                      obscureText: false,
                      maxLine: 20,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Tên Tòa Nhà Chung Cư
                    RequiredTextForm(
                      controller: contentController,
                      hintText: "Nội dung lỗi".tr(),
                      icon: Icon(Icons.article),
                      obscureText: false,
                      maxLine: 50,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RequiredTextForm(
                      controller: finedController,
                      hintText: "Hình phạt".tr(),
                      icon: Icon(Icons.gavel),
                      obscureText: false,
                      maxLine: 50,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    GestureDetector(
                      onTap: addViolate,
                      child: MyButton(
                        text: "Thêm".tr(),
                        color: Colors.black,
                        colorText: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
