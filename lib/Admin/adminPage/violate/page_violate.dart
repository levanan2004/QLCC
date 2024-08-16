import 'package:apartment_management/Admin/adminPage/violate/item_violate.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViolatePage extends StatefulWidget {
  const ViolatePage({super.key});

  @override
  State<ViolatePage> createState() => _ViolatePageState();
}

class _ViolatePageState extends State<ViolatePage> {
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

  void itemPageViolateClick(String idDocViolate, String email) async {
    DocumentSnapshot a = await FirebaseFirestore.instance
        .collection('Violate')
        .doc(idDocViolate)
        .get();
    if (a['StatusHandle'] == false) {
      setState(() {
        FirebaseFirestore.instance
            .collection('Violate')
            .doc(idDocViolate)
            .update({'StatusHandle': true});
      });
      FirebaseFirestore.instance.collection('Notifications').add({
        'Title': 'Bạn vừa gỡ được 1 lỗi vi phạm',
        'Content': 'bạn đã hết vi phạm 1 lỗi nào đó',
        'UserEmail': email,
        'Timestamp': Timestamp.now(),
        'Status': false
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Danh sách vi phạm nội quy',
            style: TextStyle(
                fontSize: 20, fontFamily: "Urbanist", color: Colors.black)),
      ),
      body: code == null
          ? Circular()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Violate')
                  .where('CODE', isEqualTo: code)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final indexUM = snapshot.data!.docs[index];
                      // bool isCurrentUser = message['UserEmail'] == email;
                      return ItemPageViolate(
                        onTap: () =>
                            itemPageViolateClick(indexUM.id, indexUM['Email']),
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
