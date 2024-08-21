import 'package:apartment_management/User/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAccount extends StatefulWidget {
  const MyAccount({super.key});

  @override
  State<MyAccount> createState() => _MyAccountState();
}

class _MyAccountState extends State<MyAccount> {
  final email = FirebaseAuth.instance.currentUser!.email;
  Future<void> editField(String field, fieldInfo) async {
    String newValue = "";
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: Text(
                "Chỉnh sửa ".tr() + fieldInfo,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Urbanist"),
              ),
              content: TextField(
                autofocus: true,
                style: const TextStyle(
                    color: Colors.black, fontFamily: "Urbanist"),
                decoration: InputDecoration(
                    hintText: "Nhập thông tin".tr(),
                    hintStyle: const TextStyle(
                        color: Colors.black, fontFamily: "Urbanist")),
                onChanged: (value) => {newValue = value},
              ),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      "Hủy".tr(),
                      style: const TextStyle(
                          color: Colors.black, fontFamily: "Urbanist"),
                    )),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(newValue),
                    child: Text(
                      "Lưu".tr(),
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
                    title: Text("Cách thức nhập sai".tr(),
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Urbanist")),
                    content: Text(
                        "\nNhập 1: nếu là nam \nNhập 0: nếu là nữ".tr(),
                        style: const TextStyle(
                            color: Colors.black, fontFamily: "Urbanist")),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            "Đóng".tr(),
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
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tài Khoản".tr()),
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
            return Center(child: Text("Đã xảy ra lỗi").tr());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
                child: Text("Không tìm thấy thông tin tài khoản").tr());
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
                  sectionName: "Họ tên".tr(),
                  text: userData['username'] ?? "...",
                  onPressed: () => editField('username', "Họ tên".tr())),
              (userData['role'] == "1")
                  ? MyTextBox(sectionName: "Vai trò".tr(), text: "Quản lý".tr())
                  : MyTextBox(
                      sectionName: "Vai trò".tr(), text: "Người thuê".tr()),
              (userData['Sex'] == "1")
                  ? MyTextBox(
                      sectionName: "Giới tính".tr(),
                      text: "Nam".tr(),
                      onPressed: () => editField('Sex', "Giới tính".tr()))
                  : MyTextBox(
                      sectionName: "Giới tính".tr(),
                      text: "Nữ".tr(),
                      onPressed: () => editField('Sex', "Giới tính".tr())),
              MyTextBox(sectionName: "Email", text: userData['email'] ?? "..."),
              MyTextBox(
                sectionName: "Số điện thoại".tr(),
                text: userData['Phone'] ?? "...",
              ),
              MyTextBox(
                  sectionName: "Căn Cước Công Dân".tr(),
                  text: userData['CCCD'] ?? "...",
                  onPressed: () => editField('CCCD', "Căn cước công dân".tr())),
              MyTextBox(
                  sectionName: "Địa chỉ".tr(),
                  text: userData['Address'] ?? "...",
                  onPressed: () => editField('Address', "Địa chỉ".tr())),
              MyTextBox(
                sectionName: "Mã giới thiệu".tr(),
                text: userData['CODE'] ?? "...",
              ),
              SizedBox(height: 50),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text("Đăng Xuất".tr(),
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
