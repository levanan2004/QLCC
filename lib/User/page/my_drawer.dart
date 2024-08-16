import 'package:apartment_management/User/page/account_page.dart';
import 'package:apartment_management/User/page/message/page_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
// sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  String? email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/icon_main.png'),
                  radius: 40,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Xin chào,\n' + email!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Urbanist",
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    'Trang Chủ',
                    style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to home page
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text('Tin Nhắn',
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 20,
                          color: Colors.black)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyMessage()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text('Tài Khoản',
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 20,
                          color: Colors.black)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyAccount()));
                  },
                ),
              ],
            ),
          ),
          // Sign out button
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Đăng Xuất',
                style: TextStyle(
                    fontFamily: "Urbanist", fontSize: 20, color: Colors.black)),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}
