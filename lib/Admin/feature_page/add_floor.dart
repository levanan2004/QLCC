import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddFloor extends StatefulWidget {
  final String idApartmentBuilding;
  const MyAddFloor({super.key, required this.idApartmentBuilding});

  @override
  State<MyAddFloor> createState() => _MyAddFloorState();
}

class _MyAddFloorState extends State<MyAddFloor> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key

  // Hàm này truy xuất dữ liệu và gán dữ liệu để kiếm tra xem có nhập ApartmentName có trùng không
  Future<bool> isFloorNameExists(String floorName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ApartmentBuilding')
        .doc(widget.idApartmentBuilding)
        .collection('Floor')
        .where('Floor', isEqualTo: floorName)
        .get();
    return querySnapshot.size > 0;
  }

  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Text Controller
  final FloorController = TextEditingController();
  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataF() async {
    if (_formKey.currentState!.validate()) {
      // Only post if there is something in the TextField
      if (FloorController.text.isNotEmpty) {
        // Check if apartment name exists
        final apartmentNameExists =
            await isFloorNameExists(FloorController.text.trim());
        if (apartmentNameExists) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Tầng này không tồn tại".tr()),
                content: Text(
                    "Một tầng có cùng tên đã tồn tại trên Tòa nhà chung cư này."
                        .tr()),
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
        } else {
          FirebaseFirestore.instance
              .collection('ApartmentBuilding')
              .doc(widget.idApartmentBuilding)
              .collection('Floor')
              .add({
            'Floor': int.parse(FloorController.text.trim()),
          });
          Navigator.pop(context);
        }
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
                      "Thêm Tầng Lầu".tr(),
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
                    // Tầng Số
                    RequiredTextForm(
                        maxLine: 2,
                        controller: FloorController,
                        hintText: "Tầng số (vd: 7,..)".tr(),
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
                      onTap: addDataF,
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
