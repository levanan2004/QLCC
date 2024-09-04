import 'package:apartment_management/Admin/adminPage/Rules/page_rules.dart';
import 'package:apartment_management/Auth/register/add_code.dart';
import 'package:apartment_management/User/page/drawer/account_page.dart';
import 'package:apartment_management/User/page/drawer/message/page_message.dart';
import 'package:apartment_management/User/page/room_service/u_room_page.dart';
import 'package:apartment_management/User/page/room_service/u_service_get_apartmentbuilding.dart';
import 'package:apartment_management/User/page/violate/u_page_violate.dart';
import 'package:apartment_management/admob/banner.dart';
import 'package:apartment_management/admob/interstitial.dart';
import 'package:apartment_management/admob/open_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_MyRoomTenantService extends StatefulWidget {
  const User_MyRoomTenantService({
    super.key,
  });

  @override
  State<User_MyRoomTenantService> createState() =>
      _User_MyRoomTenantServiceState();
}

class _User_MyRoomTenantServiceState extends State<User_MyRoomTenantService> {
  final email = FirebaseAuth.instance.currentUser!.email;
  String? code;

  // <quảng cáo Trung gian(Interstitial)>
  final InterstitialAdService _interstitialAdService = InterstitialAdService();
  void _showInterstitialAd() {
    _interstitialAdService.showInterstitialAd();
  }
  // </quảng cáo Trung gian(Interstitial)>

  final AppOpenAdService _adService = AppOpenAdService();
  @override
  void initState() {
    super.initState();
    checkUserCode();
    // Chạy quảng cáo Mở Ứng Dụng
    _adService.loadAd();
    // Khởi tạo Trung gian(Interstitial) khi vừa sang trang này
    _interstitialAdService.loadInterstitialAd();
  }

  void checkUserCode() async {
    DocumentSnapshot doc =
        await FirebaseFirestore.instance.collection('Users').doc(email).get();
    setState(() {
      code = doc['CODE'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return code != 'chuanhapcode'
        ? Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ContainerAnh(),
                  // Apartment và ServiceAll
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // quảng cáo banner
                          BannerAdWidget()
                        ],
                      ),
                      SizedBox(
                        height: 30,
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
                      User_SBRoomTenant(),
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
                      User_ServiceGet_idApartmentBuilding(),
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
                      Row(children: [
                        // Tài khoản
                        Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyAccount()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: Colors.brown[400]),
                                    margin: const EdgeInsets.only(
                                        top: 25, left: 20, right: 5),
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
                        // Vị phạm
                        Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => User_ViolatePage()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.red),
                                      margin: const EdgeInsets.only(
                                          top: 25, left: 20, right: 5),
                                      child: Icon(
                                        Icons.gavel,
                                        color: Colors.white,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                        // Tin nhắn
                        Container(
                          width: 100,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                              onTap: () {
                                _showInterstitialAd();

                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => MyMessage()));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      padding: EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: Colors.deepPurple),
                                      margin: const EdgeInsets.only(
                                          top: 25, left: 20, right: 5),
                                      child: Icon(
                                        Icons.forum,
                                        color: Colors.white,
                                      )),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
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
                      ]),
                      Row(
                        children: [
                          Container(
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                            child: GestureDetector(
                                onTap: () {
                                  _showInterstitialAd();
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => RulesPage()));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        padding: EdgeInsets.all(20),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: Colors.greenAccent),
                                        margin: const EdgeInsets.only(
                                            top: 25, left: 20, right: 5),
                                        child: Icon(
                                          Icons.text_snippet_outlined,
                                          color: Colors.white,
                                          size: 30,
                                        )),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
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
                  ),
                ],
              ),
            ),
          )
        : Center(
            child: Column(
              children: [
                Text("Người dùng chưa nhập CODE của quản lý đưa, hãy nhấn vào Thêm CODE")
                    .tr(),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MyAddCODE()));
                    },
                    child: Text("Thêm Mã mời").tr())
              ],
            ),
          );
  }
}

class ContainerAnh extends StatelessWidget {
  const ContainerAnh({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/image_apartment.jpg'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
          Colors.black.withOpacity(.8),
          Colors.black.withOpacity(.5)
        ])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Trang Chủ".tr(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 50,
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
