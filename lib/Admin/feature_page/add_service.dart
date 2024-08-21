import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:apartment_management/User/components/text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddService extends StatefulWidget {
  final String idApartmentBuilding;
  const MyAddService({super.key, required this.idApartmentBuilding});

  @override
  State<MyAddService> createState() => _MyAddServiceState();
}

class _MyAddServiceState extends State<MyAddService> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key

  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Text Controller
  final ServiceNameController = TextEditingController();
  final MonthController = TextEditingController();
  // Button thêm các dữ liệu trong các TextField vào firebase

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
                      "Nhập thông tin dịch vụ của bạn".tr(),
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
                    // Tháng
                    MyTextFormField(
                        controller: MonthController,
                        hintText: "Tháng (vd: 1, 2,...)".tr(),
                        icon: Icon(Icons.timer_sharp),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Tên dịch vụ muốn thêm
                    RequiredTextForm(
                        maxLine: 12,
                        controller: ServiceNameController,
                        hintText: "Tên Dịch Vụ (vd: Tiền Rác,..)".tr(),
                        icon: Icon(Icons.ballot_rounded),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    _addServiceButton(),
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

  Widget _addServiceButton() {
    return GestureDetector(
      onTap: () {
        if (_formKey.currentState!.validate()) {
          if (ServiceNameController.text.isNotEmpty) {
            FirebaseFirestore.instance
                .collection('ApartmentBuilding')
                .doc(widget.idApartmentBuilding)
                .collection('ServiceAll')
                .add({
              // Nếu người dùng không nhập Tháng
              'ServiceName': ServiceNameController.text.trim(),
              'IdService': ServiceNameController.text
                  .trim()
                  .replaceAll(" ", "")
                  .replaceAll(RegExp(r'[^\w]'), "")
                  .toLowerCase(),
              'Month': Timestamp.now().toDate().month,
            });

            Navigator.pop(context);

            Navigator.pop(context);
          } else if (MonthController.text.isNotEmpty) {
            FirebaseFirestore.instance
                .collection('ApartmentBuilding')
                .doc(widget.idApartmentBuilding)
                .collection('ServiceAll')
                .add({
              // Nếu người dùng nhập Tháng
              'ServiceName': ServiceNameController.text.trim(),
              'IdService': ServiceNameController.text
                  .trim()
                  .replaceAll(" ", "")
                  .replaceAll(RegExp(r'[^\w]'), "")
                  .toLowerCase(),
              'Month': MonthController.text.trim(),
            });
            Navigator.pop(context);
            Navigator.pop(context);
          } else {
            AlertDialog(
              content: Text("Hãy nhập đủ khung".tr()),
            );
          }
        }
      },
      child: MyButton(
        text: "Thêm".tr(),
        color: Colors.black,
        colorText: Colors.white,
      ),
    );
  }
}
