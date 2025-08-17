import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/text_post.dart';
import 'package:apartment_management/User/page/drawer/message/item_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
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
  final TextEditingController _textController = TextEditingController();

  // di chuyển khi xuống cuối tin nhắn sau khi chuyển trang
  FocusNode myFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    fetchCODE();
    // add listener khi focus node
    myFocusNode.addListener(() {
      if (myFocusNode.hasFocus) {
        // Tạo độ trễ của bàn phím để có time hiển thị
        // Sau đó lượng không gian còn lại sẽ được tính toán
        // Sau đó cuộn xuống
        Future.delayed(const Duration(milliseconds: 500), () => scrollDown());
      }
    });
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    _textController.dispose();
    super.dispose();
  }

  // scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown() {
    _scrollController.animateTo(_scrollController.position.maxScrollExtent,
        duration: Duration(seconds: 1), curve: Curves.fastOutSlowIn);
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
      if (_textController.text.trim().isNotEmpty) {
        try {
          // Thêm document vào collection 'Message'.doc(code).collection('Post')
          await FirebaseFirestore.instance
              .collection('Message')
              .doc(code)
              .collection('Post')
              .add({
            'UserEmail': email,
            'Message': _textController.text.trim(),
            'TimeStamp': Timestamp.now(),
            'Likes': [],
          });
          _textController.clear();
          // Cuộn xuống sau khi gửi tin nhắn
          scrollDown();
          // Ẩn bàn phím bằng cách di chuyển sự chú ý ra khỏi TextField
          FocusScope.of(context).unfocus();

          print('Gửi tin nhắn thành công');
        } catch (e) {
          print('Error posting message: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Nếu code chưa load xong thì show loading tránh lỗi null
    if (code == null) {
      return const Scaffold(
        body: Center(child: Circular()),
      );
    }
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Tin Nhắn".tr(),
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontFamily: "Urbanist",
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
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
                      controller: _scrollController,
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
                      child: Text('Lỗi: {snapshot.error}'),
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
                      controller: _textController,
                      hintText: "Nhập tin nhắn".tr(),
                      focusNode: myFocusNode,
                      obscureText: false,
                      ontap: () {
                        // Cuộn xuống khi người dùng nhấp vào TextField
                        scrollDown();
                      },
                    ),
                  ),
                  // Button Gửi
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromARGB(255, 12, 233, 170)),
                    child: IconButton(
                      onPressed: postMessage,
                      icon: const Icon(
                        Icons.arrow_upward,
                        color: Colors.white,
                        size: 30,
                      ),
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
