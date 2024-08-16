import 'package:apartment_management/Auth/google_login.dart';
import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/email_textformf.dart';
import 'package:apartment_management/User/components/password_textformfield.dart';
import 'package:apartment_management/User/components/required_textformf.dart';
import 'package:apartment_management/Auth/forget_password_page.dart';
import 'package:apartment_management/User/components/sex_textformf.dart';
import 'package:apartment_management/User/components/square_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserRegisterPage extends StatefulWidget {
  final Function()? onTap;
  const UserRegisterPage({super.key, this.onTap});

  @override
  State<UserRegisterPage> createState() => _UserRegisterPageState();
}

class _UserRegisterPageState extends State<UserRegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key
  // Text Controller
  final userNameTextController = TextEditingController();
  final emailTextController = TextEditingController();

  final CodeController = TextEditingController();
  final SexController = TextEditingController();
  final PhoneController = TextEditingController();
  final CCCDController1 = TextEditingController();
  final AddressController = TextEditingController();
  final passwordTextController = TextEditingController();
  final confirmPasswordTextController = TextEditingController();
  // Thêm Thông báo
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

  // Đăng ký tài khoản người dùng
  void signUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: Circular(),
            ));

    // make sure passwords match
    if (passwordTextController.text != confirmPasswordTextController.text) {
      // pop loading circle
      Navigator.pop(context);

      // show error to user
      displayMessage("Mật khẩu không trùng nhau");
      return;
    }

    // try creating the user
    try {
      //<code. Kiểm tra xem người dùng nhập CODE có tồn tại không>
      final code = CodeController.text.trim();
      final codeQuery = FirebaseFirestore.instance
          .collection('ApartmentBuilding')
          .where('CODE', isEqualTo: code)
          .limit(1)
          .get();

      // Chờ kiểm tra CODE đến khi hoàn thành
      final querySnapshot = await codeQuery;

      if (querySnapshot.docs.isEmpty) {
        // Vòng tròn tải Pop
        Navigator.pop(context);

        // Hiển thị thông báo lỗi nếu mã không tồn tại
        displayMessage("CODE bạn nhập sai!");
        return;
      }
      // </code - kết thúc>
      if (_formKey.currentState!.validate()) {
        if (userNameTextController.text.isNotEmpty ||
            emailTextController.text.isNotEmpty ||
            CodeController.text.isNotEmpty ||
            PhoneController.text.isNotEmpty ||
            SexController.text.isNotEmpty ||
            CCCDController1.text.isNotEmpty ||
            AddressController.text.isNotEmpty ||
            passwordTextController.text.isNotEmpty ||
            confirmPasswordTextController.text.isNotEmpty) {
          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                  email: emailTextController.text.trim(),
                  password: passwordTextController.text.trim());
          // sau khi tạo người dùng, hãy tạo một tài liệu mới trong cloud firestore có tên là Users
          FirebaseFirestore.instance
              .collection("Users")
              .doc(userCredential.user!.email)
              .set({
            'email': emailTextController.text.trim(),
            'username': userNameTextController.text.trim(),
            'idApartmentBuilding': "a",
            'idApartmentFloor': "a",
            'idApartment': "a",
            'idApartmentName': 999,
            'role': "2",
            'CODE': code,
            'Phone': PhoneController.text.trim(),
            'CCCD': CCCDController1.text.trim(),
            'Address': AddressController.text.trim(),
            'Sex': SexController.text.trim(),
          });
          AddNotificationToAdmin(code, emailTextController.text.trim());
        }
      }

      // Vòng tròn tải Pop
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      // Vòng tròn tải Pop
      Navigator.pop(context);

      //hiển thị thông báo lỗi
      displayMessage(e.code);
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
                        hintText: "Tên Người dùng",
                        icon: Icon(Icons.person),
                        obscureText: false),
                    EmailTextForm(
                        controller: emailTextController,
                        hintText: "Email",
                        icon: Icon(Icons.email),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    RequiredTextForm(
                        maxLine: 14,
                        controller: CodeController,
                        hintText: "Nhập mã code",
                        icon: Icon(Icons.code),
                        obscureText: false), // Số Điện Thoại
                    RequiredTextForm(
                        maxLine: 12,
                        controller: PhoneController,
                        hintText: "Số điện thoại",
                        icon: Icon(Icons.phone_android),
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
                    // Huyện / Quận, Thành Phố
                    RequiredTextForm(
                        maxLine: 30,
                        controller: AddressController,
                        hintText: "Địa chỉ",
                        icon: Icon(Icons.location_on),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Số Lượng Tầng Trong Tòa Nhà Chung Cư
                    RequiredTextForm(
                        maxLine: 12,
                        controller: CCCDController1,
                        hintText: "Căn Cước Công Dân",
                        icon: Icon(Icons.assignment_ind_rounded),
                        obscureText: false),
                    PasswordTextForm(
                        controller: passwordTextController,
                        hintText: "Mật khẩu",
                        icon: Icon(Icons.lock),
                        obscureText: true),
                    PasswordTextForm(
                        controller: confirmPasswordTextController,
                        hintText: "Nhập lại mật khẩu",
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
                        text: "Đăng ký",
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
                    _buildGoogleButton(),
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
            Navigator.push(
                context, MaterialPageRoute(builder: (_) => ForgetPassword()));
          },
          child: const Text(
            "Quên mật khẩu?",
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
        Text("Bạn đã có tài khoản? ",
            style: TextStyle(
              fontFamily: 'Urbanist',
              fontSize: 15,
              color: Color(0xFF1E232C),
            )),
        GestureDetector(
          onTap: widget.onTap,
          child: const Text(
            " Đăng nhập, ngay!",
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

  Widget _buildGoogleButton() {
    return Column(
      children: [
        // Or Continue With
        Row(
          children: [
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Hoặc đăng nhập với",
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  fontSize: 14,
                  color: Color(0xFF6A707C),
                ),
              ),
            ),
            Expanded(
                child: Divider(
              thickness: 0.5,
              color: Colors.grey[400],
            )),
          ],
        ),
        const SizedBox(
          height: 50,
        ),
        // Google + Phone sign in button
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // google button
            SquareTile(
                imagePath: 'assets/icons/icon_google.png',
                onTap: () => AuthService().signInWithGoogle()),
            SizedBox(
              width: 10,
            ),
            SquareTile(
                imagePath: 'assets/icons/icon_phone.png',
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Chức Năng Chưa Hoàn Thiện'),
                        content: Text(
                            'Bạn vui lòng thử lại sau, chức năng hiện tại chưa hoàn thiện'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Đóng'),
                          ),
                        ],
                      );
                    },
                  );
                }),
          ],
        ),

        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
