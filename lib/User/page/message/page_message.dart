import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/text_post.dart';
import 'package:apartment_management/User/page/message/item_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyMessage extends StatefulWidget {
  const MyMessage({super.key});

  @override
  State<MyMessage> createState() => _MyMessageState();
}

class _MyMessageState extends State<MyMessage> {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String? code;

  // Text controller
  final textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchCODE();
  }

  // Hàm lấy CODE từ Firestore
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

  // GỬi message
  void postMessage() async {
    if (code != null) {
      try {
        // Thêm document vào collection 'Message'.doc(code).collection('Post')
        await FirebaseFirestore.instance
            .collection('Message')
            .doc(code)
            .collection('Post')
            .add({
          'UserEmail': email,
          'Message': textController.text.trim(),
          'TimeStamp': Timestamp.now(),
          'Likes': [],
        });
        textController.clear();
        print('Gửi tin nhắn thành công');
      } catch (e) {
        print('Error posting message: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Tin nhắn",
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: "Urbanist",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Message')
                    .doc(code)
                    .collection('Post')
                    .orderBy('TimeStamp')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final message = snapshot.data!.docs[index];
                        bool isCurrentUser = message['UserEmail'] == email;
                        return itemPageMessage(
                          content: message['Message'],
                          userEmail: message['UserEmail'],
                          timeStamp: message['TimeStamp'],
                          isCurrentUser: isCurrentUser,
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
            ),
            // Gửi tin nhắn
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(
                    child: MyTextFieldPost(
                      controller: textController,
                      hintText: "Nhập tin nhắn",
                      obscureText: false,
                    ),
                  ),
                  // Button Gửi
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      Icons.send,
                      color: Colors.blue,
                      size: 30,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
