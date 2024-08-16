import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:apartment_management/User/page/u_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddCODE extends StatefulWidget {
  const MyAddCODE({
    super.key,
  });

  @override
  State<MyAddCODE> createState() => _MyAddCODEState();
}

class _MyAddCODEState extends State<MyAddCODE> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key

  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // Text Controller
  final codeController = TextEditingController();
  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataF() async {
    if (_formKey.currentState!.validate()) {
      // Only post if there is something in the TextField
      if (codeController.text.isNotEmpty) {
        try {
          //<code. Kiểm tra xem người dùng nhập CODE có tồn tại không>
          final code = codeController.text.trim();
          final codeQuery = await FirebaseFirestore.instance
              .collection('ApartmentBuilding')
              .where('CODE', isEqualTo: code)
              .limit(1)
              .get();

          // Chờ kiểm tra CODE đến khi hoàn thành
          final querySnapshot = await codeQuery;
          // Nếu code này không có trùng cái nào tức là ko có thì trả về(nhập sai)
          if (querySnapshot.docs.isEmpty) {
            // Vòng tròn tải Pop
            displayMessage("CODE bạn nhập sai!");

            // Hiển thị thông báo lỗi nếu mã không tồn tại

            return;
          }
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => MyAddCODE()));
          FirebaseFirestore.instance
              .collection('Users')
              .doc(currentUser.email)
              .update({'CODE': codeController.text.trim()});
          //<Thông báo cho Admin - rằng mới cú users mới tạo>
          AddNotificationToAdmin(code, currentUser.email!);

          // </Thông báo cho Admin - Kết thúc>
          // </code - kết thúc>on FirebaseAuthException catch (e) {
          Navigator.push(
              context, MaterialPageRoute(builder: (_) => User_HomePage()));
        } on FirebaseAuthException catch (e) {
          // Vòng tròn tải Pop
          Navigator.pop(context);

          //hiển thị thông báo lỗi
          displayMessage(e.code);
        }
      }
    }
  }

  // Display a dialog message
  void displayMessage(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Center(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: "Urbanist",
                  ),
                ),
              ),
            ));
  }

  void AddNotificationToAdmin(String code, String email) async {
    // <KTVT. Kiểm tra và thêm vào Users(Admin) 1 notification là: "người dùng xyz tham gia vào Tòa Nhà Chung Cư / Nhà Trọ của bạn">
    // Tham chiếu đến Collection('Users')
    CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('Users');
    // Lấy tất cả documents trong collection 'Users'
    QuerySnapshot usersSnapshotDocs = await usersCollection.get();
    // Truy xuất từng docs của Collection('Users')
    for (QueryDocumentSnapshot userDoc in usersSnapshotDocs.docs) {
      // Truy cập vào Collection('CODE') của Users
      CollectionReference codeCollection =
          usersCollection.doc(userDoc.id).collection('CODE');
      // lấy nó
      QuerySnapshot codeSnapshot = await codeCollection.get();
      // Truy xuất từng docs của Collection('CODE')
      for (QueryDocumentSnapshot codeDoc in codeSnapshot.docs) {
        if (codeDoc.get('ApartmentBuildingCode') == code) {
          await usersCollection
              .doc(userDoc.id)
              .collection('Notifications')
              .add({
            'Title': 'Người dùng ${email} vừa đăng ký tài khoản!',
            'Content': 'Hãy mau sắp xếp chỗ ở cho người dùng ${email}',
            'UserEmail': email,
            'Status': false,
            'Timestamp': Timestamp.now(),
          });
        }
      }
    }
    // </KTVT. Kết thúc>
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
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => MyAddCODE())),
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
                      "Thêm CODE - Mã Mời (do bạn mới tạo tài khoản)",
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
                        maxLine: 14,
                        controller: codeController,
                        hintText: "Nhập code của quản lý đưa",
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
