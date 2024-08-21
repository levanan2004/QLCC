import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/number_textform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddServiceMonth extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceName;
  const MyAddServiceMonth({
    super.key,
    required this.idApartmentBuilding,
    required this.idServiceAll,
    required this.idServiceName,
  });

  @override
  State<MyAddServiceMonth> createState() => _MyAddServiceMonthState();
}

class _MyAddServiceMonthState extends State<MyAddServiceMonth> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Text Controller
  final MonthController = TextEditingController();
  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataSM() {
    if (_formKey.currentState!.validate()) {
      // Only post if there is something in the TextField
      if (MonthController.text.isNotEmpty) {
        FirebaseFirestore.instance
            .collection('ApartmentBuilding')
            .doc(widget.idApartmentBuilding)
            .collection('ServiceAll')
            .doc(widget.idServiceAll)
            .collection('Month')
            .add({
          'Month': int.parse(MonthController.text.trim()),
        });
        // Intent sang page MyApartment của ApartmentBuilding vừa tạo
        Navigator.pop(context);
      }
      ;
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
                    Text(
                      "Thêm Tháng".tr(),
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
                    // Tên Tòa Nhà Chung Cư
                    NumberTextForm(
                        controller: MonthController,
                        hintText: "Nhập Tháng(vd: 1,2,..12)".tr(),
                        icon: Icon(Icons.person),
                        obscureText: false),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    GestureDetector(
                      onTap: addDataSM,
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
