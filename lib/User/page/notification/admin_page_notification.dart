import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/page/notification/item_page_notification.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NotificationsAdminPage extends StatefulWidget {
  @override
  State<NotificationsAdminPage> createState() => _NotificationsAdminPageState();
}

class _NotificationsAdminPageState extends State<NotificationsAdminPage> {
  String email = FirebaseAuth.instance.currentUser!.email!;
  void itemPageNotificationClick(String idDocNotifications) {
    Navigator.pop(context);
    setState(() {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(email)
          .collection('Notifications')
          .doc(idDocNotifications)
          .update({'Status': true});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Thông báo'),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(email)
                .collection('Notifications')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final indexOfAdminNotificaiton =
                          snapshot.data!.docs[index];
                      return itemPageNotification(
                          onTap: () => itemPageNotificationClick(
                              indexOfAdminNotificaiton.id),
                          title: indexOfAdminNotificaiton['Title'],
                          content: indexOfAdminNotificaiton['Content'],
                          status: indexOfAdminNotificaiton['Status'],
                          userEmail: indexOfAdminNotificaiton['UserEmail'],
                          timeStamp: indexOfAdminNotificaiton['Timestamp']);
                    });
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error:${snapshot.error}'),
                );
              }
              return Center(
                child: Circular(),
              );
            }));
  }
}
