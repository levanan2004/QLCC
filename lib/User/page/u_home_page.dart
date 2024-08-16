import 'package:apartment_management/User/page/my_drawer.dart';
import 'package:apartment_management/User/page/notification/user_page_notification.dart';
import 'package:apartment_management/User/page/room_service/u_room_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class User_HomePage extends StatefulWidget {
  User_HomePage({super.key});

  @override
  State<User_HomePage> createState() => _User_HomePageState();
}

class _User_HomePageState extends State<User_HomePage> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    final userName = userEmail!.split('@')[0];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _IconButtonHelp(),
            Text(userName),
          ],
        ),
        actions: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Notifications')
                .where('UserEmail', isEqualTo: userEmail)
                .where('Status', isEqualTo: false)
                .snapshots(),
            builder: (context, snapshot) {
              bool hasUnreadNotifications = false;
              if (snapshot.hasData) {
                hasUnreadNotifications = snapshot.data!.docs.isNotEmpty;
              }
              return hasUnreadNotifications
                  ? GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationsUserPage()),
                        );
                      },
                      child: Lottie.asset(
                          'assets/animation/notification_dynamic.json'))
                  : GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => NotificationsUserPage()),
                        );
                      },
                      child: Lottie.asset(
                          'assets/animation/notification_static.json'));
            },
          ),
        ],
      ),
      body: User_MyRoomTenantService(),
      drawer: MyDrawer(),
    );
  }

  // Icon Button Help (Nút hướng dẫn)
  Widget _IconButtonHelp() {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Cách sử dụng app'),
                content: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Nếu bạn chưa thấy Căn hộ ',
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.elevator,
                      size: 20,
                      color: Color.fromARGB(255, 163, 214, 184),
                    ),
                  ),
                  TextSpan(
                    text: ' của mình hãy báo chủ căn hộ\n',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: '\nNếu bạn chưa thấy các ',
                    style: TextStyle(color: Colors.black),
                  ),
                  WidgetSpan(
                    child: Icon(
                      Icons.shop_2,
                      size: 20,
                      color: Color.fromARGB(255, 149, 208, 238),
                    ),
                  ),
                  TextSpan(
                    text: ' của mình hãy báo chủ căn hộ',
                    style: TextStyle(color: Colors.black),
                  ),
                ])),
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
        },
        icon: Icon(
          Icons.help,
          size: 20,
          color: Colors.grey,
        ));
  }
}
