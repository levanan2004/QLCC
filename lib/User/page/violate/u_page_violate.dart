import 'package:apartment_management/Admin/adminPage/violate/item_violate.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_ViolatePage extends StatefulWidget {
  const User_ViolatePage({super.key});

  @override
  State<User_ViolatePage> createState() => _User_ViolatePageState();
}

class _User_ViolatePageState extends State<User_ViolatePage> {
  String email = FirebaseAuth.instance.currentUser!.email!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách vi phạm nội quy".tr(),
            style: TextStyle(
                fontSize: 20, fontFamily: "Urbanist", color: Colors.black)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('Violate')
            .where('Email', isEqualTo: email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final indexUM = snapshot.data!.docs[index];
                // bool isCurrentUser = message['UserEmail'] == email;
                return ItemPageViolate(
                  content: indexUM['Content'],
                  fined: indexUM['Fined'],
                  status: indexUM['StatusHandle'],
                  timeStamp: indexUM['TimeStamp'],
                  title: indexUM['Title'],
                  userEmail: indexUM['Email'],
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
