import 'dart:math';
import 'package:apartment_management/Admin/adminPage/apartment_building.dart';
import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddAB extends StatefulWidget {
  const MyAddAB({super.key});

  @override
  State<MyAddAB> createState() => _MyAddABState();
}

class _MyAddABState extends State<MyAddAB> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key

  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Hàm kiểm tra xem người dùng đã tạo bao nhiêu Apartment Building
  Future<int> AmountApartmentBuildingOfEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('ApartmentBuilding')
        .where('Email', isEqualTo: email)
        .get();

    // Đếm số lượng tài liệu trong kết quả truy vấn
    final emails =
        querySnapshot.docs.map((doc) => doc['Email'] as String).toList();
    return emails.length;
  }

  // Tạo code AP (1)
  String randomCode() {
    String code = "APCODE" + Random().nextInt(10000000).toString();
    return code;
  }

  // Text Controller
  final ApartmentBuildingNameController = TextEditingController();
  final OwnController = TextEditingController();
  final PhoneController = TextEditingController();
  final AddressController1 = TextEditingController();
  final AddressController2 = TextEditingController();
  final AmountFloorController = TextEditingController();
  final AmountController = TextEditingController();
  // Hàm thêm dữ liệu 'ApartmentBuildingCode' của User == với 'CODE' của ApartmentBuilding
  void _addApartmentBuildingCode(String code) async {
    final user = FirebaseAuth.instance.currentUser;
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user!.email)
        .collection('CODE')
        .add({'ApartmentBuildingCode': code});
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .update({'CODE': code});
  }

  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataAB() async {
    // Only post if there is something in the TextField
    if (_formKey.currentState!.validate()) {
      if (ApartmentBuildingNameController.text.isNotEmpty ||
          OwnController.text.isNotEmpty ||
          PhoneController.text.isNotEmpty ||
          AddressController1.text.isNotEmpty ||
          AddressController2.text.isNotEmpty ||
          AmountFloorController.text.isNotEmpty ||
          AmountController.text.isNotEmpty) {
        // Check if apartment name exists
        final int EmailExistsOverAccept =
            await AmountApartmentBuildingOfEmail(currentUser.email.toString());
        // Nếu người dùng đã tạo hơn 2 AP sẽ không tạo được nửa (EmailExistsOverAccept > 1 tức EmailExistsOverAccept phải 2 mới không tạo được nữa)
        if (EmailExistsOverAccept > 0) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Thông báo'),
                content: Text(
                    'Số lượng tòa nhà chung cư bạn tạo đã đạt mức giới hạn.'),
                actions: [
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          final code = randomCode();
          bool codeExists = true;
          // Kiểm tra xong nếu code trùng với CODE ở database
          final querySnapshot = await FirebaseFirestore.instance
              .collection('ApartmentBuilding')
              .where('CODE', isEqualTo: code)
              .get();
          // codeExists = true nếu tìm thấy 1 cái code giống code vừa tạo (querySnapshot.size > 0)
          codeExists = querySnapshot.size > 0;
          // Exit if a unique code is found
          if (codeExists) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Có lỗi đã tồn tại'),
                  content: Text('Xin vui lòng hãy thoát ra và tạo lại'),
                  actions: [
                    TextButton(
                      child: Text('Đóng'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                );
              },
            );
          } else {
            FirebaseFirestore.instance.collection('ApartmentBuilding').add({
              'ApartmentBuildingName':
                  ApartmentBuildingNameController.text.trim(),
              'Email': currentUser.email,
              'Hamlet': AddressController1.text.trim(),
              'City': AddressController2.text.trim(),
              'Amount': AmountController.text.trim(),
              'AmountFloor': AmountFloorController.text.trim(),
              'Own': OwnController.text.trim(),
              'Phone': PhoneController.text.trim(),
              'CODE': code,
              'TimeStamp': Timestamp.now(),
            }).then((documentReference) {
              String newDocumentId = documentReference.id;
              // Xem người dùng có nhập vào Số Tầng = 0 hay không
              if (int.parse(AmountFloorController.text.trim()) > 0) {
                int a = int.parse(AmountFloorController.text.trim());
                for (int i = 0; i < a; i++) {
                  FirebaseFirestore.instance
                      .collection('ApartmentBuilding')
                      .doc(newDocumentId)
                      .collection('Floor')
                      .add({
                    'Floor': i + 1,
                  });
                }
                ;
                // Thêm dịch vụ Tiền Rác
                // FirebaseFirestore.instance
                //     .collection('ApartmentBuilding')
                //     .doc(newDocumentId)
                //     .collection('ServiceAll')
                //     .add({
                //   'IdService': 'trash',
                //   'ServiceName': 'Tiền Rác',
                //   'Month': Timestamp.now().toDate().month,
                // }).then((documentReferenceServiceAll) {
                //   String newDocumentIdServiceAll =
                //       documentReferenceServiceAll.id;
                //   FirebaseFirestore.instance
                //       .collection('ApartmentBuilding')
                //       .doc(newDocumentId)
                //       .collection('ServiceAll')
                //       .doc(newDocumentIdServiceAll)
                //       .collection('Month')
                //       .add({
                //     'Month': 13,
                //   }).then((documentReferenceMonth) {
                //     String newDocumentIdMonth = documentReferenceMonth.id;
                //     FirebaseFirestore.instance
                //         .collection('ApartmentBuilding')
                //         .doc(newDocumentId)
                //         .collection('ServiceAll')
                //         .doc(newDocumentIdServiceAll)
                //         .collection('Month')
                //         .doc(newDocumentIdMonth)
                //         .collection('Room')
                //         .add({
                //       'ApartmentName': 999,
                //       'Floor': 999,
                //       'TenantEmail': 'taikhoan999@gmail.com',
                //       'Money': 999999,
                //       'Unit': 9999999,
                //       'Status': false,
                //       'TimeStamp': Timestamp.now(),
                //     });
                //   });
                // });
              }

              _addApartmentBuildingCode(code);
              // Intent sang page MyApartment của ApartmentBuilding vừa tạo
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyAdminHome(),
                ),
              );
            });
          }
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
                      "Tòa Nhà chung Cư / Trọ",
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
                        maxLine: 20,
                        controller: ApartmentBuildingNameController,
                        hintText: "Tên Tòa Chung Cư",
                        icon: Icon(Icons.house),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Tên Chủ Nhà
                    RequiredTextForm(
                        maxLine: 20,
                        controller: OwnController,
                        hintText: "Người Sở Hữu",
                        icon: Icon(Icons.person),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Số Điện Thoại
                    RequiredTextForm(
                        maxLine: 30,
                        controller: PhoneController,
                        hintText: "Số Điện Thoại",
                        icon: Icon(Icons.phone),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Ấp, Xã
                    RequiredTextForm(
                        maxLine: 30,
                        controller: AddressController1,
                        hintText: "Ấp, Xã",
                        icon: Icon(Icons.pin_drop),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Huyện / Quận, Thành Phố
                    RequiredTextForm(
                        maxLine: 30,
                        controller: AddressController2,
                        hintText: "Huyện/Quận, Thành Phố",
                        icon: Icon(Icons.place),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Số Lượng Tầng Trong Tòa Nhà Chung Cư
                    RequiredTextForm(
                        maxLine: 2,
                        controller: AmountFloorController,
                        hintText: "Số Lương Tầng",
                        requireLeadingZero: false,
                        icon: Icon(Icons.elevator),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Số Lượng Căn Hộ Của Tầng
                    RequiredTextForm(
                        maxLine: 2,
                        controller: AmountController,
                        hintText: "Số lượng Căn Hộ Mỗi Tầng",
                        icon: Icon(Icons.home),
                        obscureText: false),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Submit
                    GestureDetector(
                      onTap: addDataAB,
                      child: MyButton(
                        text: "Nộp",
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
