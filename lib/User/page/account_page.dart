import 'package:apartment_management/User/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final email = FirebaseAuth.instance.currentUser!.email;
  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Chỉnh sửa $field",
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Urbanist"),
              ),
              content: TextField(
                autofocus: true,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Urbanist"),
                decoration: InputDecoration(
                    hintText: "Nhập dữ liệu",
                    hintStyle: const TextStyle(
                        color: Colors.black, fontFamily: "Urbanist")),
                onChanged: (value) => {newValue = value},
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Hủy",
                      style: const TextStyle(
                          color: Colors.black, fontFamily: "Urbanist"),
                    )),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newValue),
                    child: Text(
                      "Lưu",
                      style: const TextStyle(
                          color: Colors.black, fontFamily: "Urbanist"),
                    ))
              ],
            ));
    // update in firestore
    if (newValue.trim().isNotEmpty) {
      if (field == 'Sex') {
        if (newValue.trim() == "1" || newValue.trim() == "0") {
          await FirebaseFirestore.instance
              .collection('Users')
              .doc(email)
              .update({field: newValue});
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Cách thức nhập sai",
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Urbanist")),
                    content: Text("\nNhập 1: nếu là nam \nNhập 0: nếu là nữ",
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Urbanist")),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Vâng",
                            style: const TextStyle(
                                color: Colors.black, fontFamily: "Urbanist"),
                          ))
                    ],
                  ));
        }
      } else {
        // only update if there is something in the textfield
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .update({field: newValue});
      }
    }
  }

  // sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tài khoản"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(email)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Đã xảy ra lỗi'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Không tìm thấy thông tin tài khoản'));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>;

          return ListView(
            padding: EdgeInsets.all(16),
            children: [
              SizedBox(
                height: 50,
              ),
              userData['Sex'] == "1"
                  ? CircleAvatar(
                      child: Image.asset(
                        'assets/avatars/avatar_boy.png',
                        fit: BoxFit.cover,
                      ),
                    )
                  : CircleAvatar(
                      child: Image.asset('assets/avatars/avatar_female.png',
                          fit: BoxFit.cover),
                    ),
              SizedBox(
                height: 20,
              ),
              MyTextBox(
                  sectionName: "Họ Tên",
                  text: userData['username'] ?? "...",
                  onPressed: () => editField('username')),
              MyTextBox(
                  sectionName: "Vai Trò", text: userData['role'] ?? "..."),
              MyTextBox(
                  sectionName: "Giới Tính",
                  text: userData['Sex'] ?? "...",
                  onPressed: () => editField('Sex')),
              MyTextBox(sectionName: "Email", text: userData['email'] ?? "..."),
              MyTextBox(
                sectionName: "Số Điện Thoại",
                text: userData['Phone'] ?? "...",
              ),
              MyTextBox(
                  sectionName: "Căn Cước Công Dân",
                  text: userData['CCCD'] ?? "...",
                  onPressed: () => editField('CCCD')),
              MyTextBox(
                  sectionName: "Đia Chỉ",
                  text: userData['Address'] ?? "...",
                  onPressed: () => editField('Address')),
              MyTextBox(
                sectionName: "Mã Giới Thiệu",
                text: userData['CODE'] ?? "...",
              ),
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('Đăng Xuất',
                    style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 20,
                        color: Colors.black)),
                onTap: signOut,
              ),
            ],
          );
        },
      ),
    );
  }
}
