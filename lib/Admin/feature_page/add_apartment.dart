import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddA extends StatefulWidget {
  final String idApartmentBuilding;
  final String idApartmentFloor;
  const MyAddA(
      {super.key,
      required this.idApartmentBuilding,
      required this.idApartmentFloor});

  @override
  State<MyAddA> createState() => _MyAddAState();
}

class _MyAddAState extends State<MyAddA> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key

  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Text Controller
  final ApartmentNameController = TextEditingController();
  final AreaController = TextEditingController();
  final PersonController = TextEditingController();
  // Hàm này truy xuất dữ liệu và gán dữ liệu để kiếm tra xem có nhập ApartmentName(Room) có trùng không
  Future<bool> isApartmentNameExists(String apartmentName) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ApartmentBuilding')
        .doc(widget.idApartmentBuilding)
        .collection('Floor')
        .doc(widget.idApartmentFloor)
        .collection('Apartment')
        .where('ApartmentName', isEqualTo: apartmentName)
        .get();
    return querySnapshot.size > 0;
  }

  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataAB() async {
    if (_formKey.currentState!.validate()) {
// Only post if there is something in the TextField
      if (ApartmentNameController.text.isNotEmpty ||
          AreaController.text.isNotEmpty ||
          PersonController.text.isNotEmpty) {
        // Check if apartment name exists
        final apartmentNameExists =
            await isApartmentNameExists(ApartmentNameController.text.trim());
        if (apartmentNameExists) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Phòng này đã tồn tại".tr()),
                content: Text("Một phòng cùng tên đã tồn tại ở tầng này.".tr()),
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
              .doc(widget.idApartmentFloor)
              .collection('Apartment')
              .add({
            'ApartmentName': int.parse(ApartmentNameController.text.trim()),
            'Area': AreaController.text.trim(),
            'Person': int.parse(PersonController.text.trim()),
            'Status': true,
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
                    const SizedBox(
                      height: 25,
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
                    Text(
                      "Nhập Thông Tin Phòng".tr(),
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
                    RequiredTextForm(
                        maxLine: 2,
                        controller: ApartmentNameController,
                        hintText: "Nhập số phòng(vd: 1,..)".tr(),
                        icon: Icon(Icons.home_outlined),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Ấp, Xã
                    RequiredTextForm(
                        maxLine: 3,
                        controller: AreaController,
                        hintText: "Diện tích phòng (m²)".tr(),
                        icon: Icon(Icons.home),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Huyện / Quận, Thành Phố
                    RequiredTextForm(
                        maxLine: 1,
                        controller: PersonController,
                        hintText: "Số lượng người (vd: 3,..)".tr(),
                        icon: Icon(Icons.group),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    GestureDetector(
                      onTap: addDataAB,
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
