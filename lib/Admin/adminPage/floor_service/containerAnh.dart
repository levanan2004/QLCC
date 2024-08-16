import 'package:apartment_management/User/page/notification/admin_page_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ContainerAnh extends StatelessWidget {
  final VoidCallback onSearchTap;
  const ContainerAnh({
    super.key,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    final userEmail = FirebaseAuth.instance.currentUser!.email;
    return Container(
      height: 300,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/image_apartment.jpg'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
          Colors.black.withOpacity(.6),
          Colors.black.withOpacity(.1)
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Users')
                      .doc(userEmail)
                      .collection('Notifications')
                      .where('Status', isEqualTo: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    bool hasUnreadNotifications = true;
                    if (snapshot.hasData) {
                      hasUnreadNotifications = snapshot.data!.docs.isNotEmpty;
                    }
                    return Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        SizedBox(
                          width: 50,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 40,
                              child: Image.asset(
                                'assets/icons/icon_arrow.png',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 250,
                        ),
                        (hasUnreadNotifications)
                            ? GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            NotificationsAdminPage()),
                                  );
                                },
                                child: Lottie.asset(
                                    'assets/animation/notification_dynamic.json'))
                            : GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            NotificationsAdminPage()),
                                  );
                                },
                                child: Lottie.asset(
                                    'assets/animation/notification_static.json'))
                      ],
                    );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "Bạn muốn tìm căn hộ?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 3),
              margin: EdgeInsets.symmetric(horizontal: 40),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50), color: Colors.white),
              child: TextField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey,
                    ),
                    hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                    hintText: 'Nhập số phòng bạn muốn tìm (vd: 1,2,...)'),
                onTap: onSearchTap,
              ),
            ),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
