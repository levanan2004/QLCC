import 'package:apartment_management/Admin/adminPage/user_management/item_user_management.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String? code;
  @override
  void initState() {
    super.initState();
    fetchCODE();
  }

  // Tìm 'CODE'
  void fetchCODE() async {
    try {
      // Truy xuất document của người dùng hiện tại từ collection 'Users'
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        // Lấy field 'CODE' từ document
        setState(() {
          code = userDoc['CODE'];
        });
      } else {
        print('Người dùng không tồn tại');
      }
    } catch (e) {
      print('Error fetching CODE: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quản lý người dùng'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .where('CODE', isEqualTo: code)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // Lọc các document dựa trên field 'role'
            var filteredUsers = snapshot.data!.docs.where((doc) {
              // Lọc bỏ các document có field 'role' bằng 1
              return !doc.data().containsKey('role') || doc['role'] != "1";
            }).toList();

            if (filteredUsers.isEmpty) {
              return Center(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: Colors.blue,
                      )),
                  Text('Không tìm thấy bất cứ người dùng nào'),
                ],
              ));
            }
            return ListView.builder(
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                final indexUM = filteredUsers[index];
                // bool isCurrentUser = message['UserEmail'] == email;
                return ItemUserManagement(
                  role: indexUM['role'],
                  email: indexUM['email'],
                  CCCD: indexUM['CCCD'],
                  address: indexUM['Address'],
                  name: indexUM['username'],
                  phone: indexUM['Phone'],
                  sex: indexUM['Sex'],
                  CODE: indexUM['CODE'],
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Lỗi: ${snapshot.error}'),
            );
          }
          return const Center(
            child: Circular(),
          );
        },
      ),
    );
  }
}
