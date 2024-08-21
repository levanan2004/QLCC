import 'package:apartment_management/Admin/adminPage/Rules/page_rules.dart';
import 'package:apartment_management/Admin/adminPage/user_management/user_management.dart';
import 'package:apartment_management/Admin/adminPage/violate/page_violate.dart';
import 'package:apartment_management/Admin/page_components/pc_floor.dart';
import 'package:apartment_management/Admin/page_components/pc_service.dart';
import 'package:apartment_management/User/page/drawer/account_page.dart';
import 'package:apartment_management/User/page/drawer/message/page_message.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ChildFloorService extends StatefulWidget {
  final String idApartmentBuilding;
  const ChildFloorService({super.key, required this.idApartmentBuilding});

  @override
  State<ChildFloorService> createState() => _ChildFloorServiceState();
}

class _ChildFloorServiceState extends State<ChildFloorService> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text("Tầng: ".tr(),
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: "Urbanist")),
          ],
        ),
        // trang này chứa code Layout và lấy dữ liệu Floor từ Firebase.
        SBFloor(idApartmentBuilding: widget.idApartmentBuilding),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 50,
        ),
        Row(
          children: [
            SizedBox(
              width: 20,
            ),
            Text("Dịch vụ: ".tr(),
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                    fontFamily: "Urbanist")),
          ],
        ),
        // trang này chứa code Layout và lấy dữ liệu ServiceAll từ Firebase.
        SBService(
          idApartmentBuilding: widget.idApartmentBuilding,
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          children: [
            // Tài khoản
            Container(
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyAccount()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.brown[400]),
                        margin:
                            const EdgeInsets.only(top: 25, left: 20, right: 5),
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tài Khoản".tr(),
                            style: TextStyle(
                                color: Colors.brown[400],
                                fontSize: 20,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            // Quản lý người dùng
            Container(
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => UserManagementPage()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepOrange),
                          margin: const EdgeInsets.only(
                              top: 25, left: 20, right: 5),
                          child: Icon(
                            Icons.group,
                            color: Colors.white,
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Quản lý".tr(),
                            style: TextStyle(
                                color: Colors.deepOrange,
                                fontSize: 20,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
            ),

            // Tin nhắn
            Container(
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyMessage()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.deepPurple),
                          margin: const EdgeInsets.only(
                              top: 25, left: 20, right: 5),
                          child: Icon(
                            Icons.forum,
                            color: Colors.white,
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Tin Nhắn".tr(),
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 20,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
        Row(
          children: [
            // Vi phạm nội quy
            Container(
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ViolatePage()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.red),
                          margin: const EdgeInsets.only(
                              top: 25, left: 20, right: 5),
                          child: Icon(
                            Icons.gavel,
                            color: Colors.white,
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Vi Phạm".tr(),
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 20,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
            ),
            // Nội quy
            Container(
              width: 100,
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => RulesPage()));
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.greenAccent),
                          margin: const EdgeInsets.only(
                              top: 25, left: 20, right: 5),
                          child: Icon(
                            Icons.text_snippet_outlined,
                            color: Colors.white,
                            size: 30,
                          )),
                      Row(
                        children: [
                          SizedBox(
                            width: 20,
                          ),
                          Text(
                            "Nội Quy".tr(),
                            style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 20,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  )),
            )
          ],
        ),
        SizedBox(
          height: 300,
        ),
      ],
    );
  }
}
