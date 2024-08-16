import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/email_textformf.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:apartment_management/User/components/sex_textformf.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddTenantApartment extends StatefulWidget {
  final String idApartmentFloor;
  final String idApartmentBuilding;
  final String idApartment;
  final int idApartmentName;
  const MyAddTenantApartment(
      {super.key,
      required this.idApartmentBuilding,
      required this.idApartmentFloor,
      required this.idApartment,
      required this.idApartmentName});

  @override
  State<MyAddTenantApartment> createState() => _MyAddTenantApartmentState();
}

class _MyAddTenantApartmentState extends State<MyAddTenantApartment> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key

  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Text Controller
  final EmailController = TextEditingController();
  final NameController = TextEditingController();
  final SexController = TextEditingController();
  // Function to validate SexController input
  bool validateSexInput(String input) {
    return input == "1" || input == "0";
  }

  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataATenant() async {
    // Only post if there is something in the TextField
    if (_formKey.currentState!.validate()) {
      if (EmailController.text.isNotEmpty ||
          NameController.text.isNotEmpty ||
          SexController.text.isNotEmpty) {
        // Check if User exists with the provided email
        String email = EmailController.text.trim();
        final userDoc = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: email)
            .get();

        if (userDoc.size > 0) {
          FirebaseFirestore.instance
              .collection('ApartmentBuilding')
              .doc(widget.idApartmentBuilding)
              .collection('Floor')
              .doc(widget.idApartmentFloor)
              .collection('Apartment')
              .doc(widget.idApartment)
              .collection('Tenant')
              .add({
            'Email': EmailController.text.trim(),
            'Name': NameController.text.trim(),
            'Sex': SexController.text.trim(),
            'TimeStamp': Timestamp.now(),
          });
          final userRef = await userDoc.docs.first.reference;
          await userRef.update({
            'idApartmentBuilding': widget.idApartmentBuilding,
            'idApartmentFloor': widget.idApartmentFloor,
            'idApartment': widget.idApartment,
            'idApartmentName': widget.idApartmentName
          });
          // Thêm tin nhắn của user khi Admin thêm Tenant vào Apartment
          FirebaseFirestore.instance.collection('Notifications').add({
            'Title': 'Bạn đã được thêm vào phòng!',
            'Content':
                'Hãy vào xem phòng của mình, bạn đã được Quản lý thêm vào 1 phòng nào đó!',
            'UserEmail': email,
            'Status': false,
            'Timestamp': Timestamp.now(),
          });
          Navigator.pop(context);
        } else {
          // Người dùng không tồn tại, hiển thị hộp thoại lỗi
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Tài khoản không tồn tại'),
              content: Text(
                  'Email "$email" không được tìm thấy trong danh sách người dùng.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
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
                      "Thêm Người Dùng",
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
                    EmailTextForm(
                      controller: EmailController,
                      hintText: "Email",
                      icon: Icon(Icons.email),
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Tên Chủ Nhà
                    RequiredTextForm(
                        maxLine: 20,
                        controller: NameController,
                        hintText: "Họ tên",
                        icon: Icon(Icons.person),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Ấp, Xã
                    SexTextForm(
                      controller: SexController,
                      hintText: "Nam: 1, Nữ: 0",
                      icon: Icon(Icons.female),
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 25,
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    GestureDetector(
                      onTap: addDataATenant,
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
