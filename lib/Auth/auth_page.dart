import 'package:apartment_management/Admin/adminPage/apartment_building.dart';
import 'package:apartment_management/Auth/login_or_register.dart';
import 'package:apartment_management/Auth/register/add_code.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/page/u_home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Nếu người dùng đã đăng nhập
          if (snapshot.hasData) {
            final currentUser = snapshot.data;

            // Lấy thông tin người dùng từ Firestore
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(currentUser!.email)
                  .get(),
              builder: (context, userSnapshot) {
                if (userSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: Circular());
                }

                if (userSnapshot.hasError) {
                  return Center(
                      child: Text('Có lỗi xảy ra: ${userSnapshot.error}'));
                }
                // Nếu kiểm tra dữ liệu trong 'Users' không có người dùng này, ta sẽ xem người dùng đã nhập 'CODE' chưa
                if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                  return MyAddCODE();
                }

                // Lấy vai trò của người dùng từ dữ liệu
                final userData =
                    userSnapshot.data!.data() as Map<String, dynamic>;
                final role = userData['role'];

                // Nếu role là 3, hiển thị dialog và đăng xuất
                if (role == '3') {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Tài Khoản Bị Khóa'),
                        content: Text('Bạn đã bị khóa tài khoản.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.signOut();
                              Navigator.pop(context);
                            },
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  });
                  return Container(); // Trả về một widget trống khi hiển thị dialog
                }

                // Điều hướng dựa trên vai trò
                if (role == '1') {
                  return MyAdminHome(); // Trang quản trị viên
                } else if (role == '2') {
                  return User_HomePage(); // Trang người dùng
                } else {
                  return Center(child: Text('Vai trò không hợp lệ.'));
                }
              },
            );
          }
          // Nếu người dùng chưa đăng nhập
          else {
            return FutureBuilder(
                future: Future.delayed(Duration(seconds: 3), () async {
                  return await LoginOrRegister();
                }),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Circular());
                  } else {
                    return LoginOrRegister();
                  }
                });
          }
        },
      ),
    );
  }
}
