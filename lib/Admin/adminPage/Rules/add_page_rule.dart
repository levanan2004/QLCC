import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddRulesPage extends StatefulWidget {
  final String cODE;
  const AddRulesPage({
    super.key,
    required this.cODE,
  });

  @override
  State<AddRulesPage> createState() => _AddRulesPageState();
}

class _AddRulesPageState extends State<AddRulesPage> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;

  // Text Controller
  final numberController = TextEditingController();
  final contentController = TextEditingController();
  final finedController = TextEditingController();
  void addRules() async {
    if (_formKey.currentState!.validate()) {
      if (numberController.text.isNotEmpty ||
          contentController.text.isNotEmpty ||
          finedController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('Rules')
            .doc(widget.cODE)
            .collection('Rule')
            .add({
          'Number': int.parse(numberController.text.trim()),
          'Content': contentController.text.trim(),
          'Fined': finedController.text.trim(),
          'CODE': widget.cODE,
          'TimeStamp': Timestamp.now()
        });
        FirebaseFirestore.instance
            .collection('Users')
            .where('CODE', isEqualTo: widget.cODE)
            .get()
            .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            FirebaseFirestore.instance.collection('Notifications').add({
              'Title': 'Nội quy đã có thay đổi',
              'Content':
                  'Hãy vào xem chi tiết ${contentController.text.trim()}, quản lý đã thay đổi nội quy',
              // Sử dụng email từ tài liệu người dùng
              'UserEmail': doc['email'],
              'Status': false,
              'Timestamp': Timestamp.now(),
            });
          }
        });
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Nhập Không Đầy Đủ'),
              content: Text('Xin vui lòng hãy nhập đủ 3 ô'),
              actions: [
                TextButton(
                  child: Text('Vâng'),
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
                    Text('Thêm nội quy',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Urbanist")),

                    const SizedBox(
                      height: 30,
                    ),
                    // STT nội quy
                    RequiredTextForm(
                      controller: numberController,
                      hintText: "STT nội quy(vd: 1,..)",
                      icon: Icon(Icons.numbers),
                      obscureText: false,
                      maxLine: 2,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Nội dung nội quy
                    RequiredTextForm(
                      controller: contentController,
                      hintText: "Nội dung nội quy",
                      icon: Icon(Icons.mode_edit_outline_outlined),
                      obscureText: false,
                      maxLine: 40,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    RequiredTextForm(
                      controller: finedController,
                      hintText: "Hình phạt",
                      icon: Icon(Icons.gavel),
                      obscureText: false,
                      maxLine: 40,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    GestureDetector(
                      onTap: addRules,
                      child: MyButton(
                        text: "Thêm",
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
