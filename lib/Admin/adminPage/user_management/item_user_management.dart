import 'package:apartment_management/Admin/adminPage/violate/add_violate_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemUserManagement extends StatefulWidget {
  final String email;
  final String name;
  final String sex;
  final String phone;
  final String role;
  final String address;
  final String CCCD;
  final String CODE;
  const ItemUserManagement(
      {super.key,
      required this.email,
      required this.name,
      required this.sex,
      required this.phone,
      required this.address,
      required this.CCCD,
      required this.role,
      required this.CODE});

  @override
  State<ItemUserManagement> createState() => Item_UserManagementState();
}

class Item_UserManagementState extends State<ItemUserManagement> {
  // Hàm block Account khi người dùng bấm vào Khóa or Mở Khóa
  void blockAccount() async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.email)
        .get();

    String currentRole = userDoc['role'];

    String newRole = currentRole == "3" ? "2" : "3";

    FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.email)
        .update({'role': newRole});
  }

  // Hàm Violte sẽ chuyển sang trang Vi Phạm
  void violate(String violateCODE, String violateEmail) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => AddViolatePage(
                  violateCODE: violateCODE,
                  violateEmail: violateEmail,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.name,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: widget.role == "2" ? Colors.green : Colors.red,
                ),
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      blockAccount();
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: widget.role == "2" ? Colors.red : Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(widget.role == "2" ? 'Khóa' : 'Mở Khóa',
                              style: TextStyle(color: Colors.white))),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      violate(widget.CODE, widget.email);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        'Vi phạm',
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Email: ${widget.email}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Giới tính: ${widget.sex}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Số điện thoại: ${widget.phone}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Địa chỉ: ${widget.address}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Text(
                  'CCCD: ${widget.CCCD}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
