import 'package:apartment_management/Admin/feature_page/add_apartment_building.dart';
import 'package:apartment_management/Admin/page_components/pc_apartment_building.dart';
import 'package:apartment_management/User/page/drawer/my_drawer.dart';
import 'package:apartment_management/admob/open_app.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAdminHome extends StatefulWidget {
  const MyAdminHome({super.key});

  @override
  State<MyAdminHome> createState() => _MyAdminHomeState();
}

class _MyAdminHomeState extends State<MyAdminHome> {
  final AppOpenAdService _adService = AppOpenAdService();
  @override
  void initState() {
    super.initState();
    // Chạy quảng cáo Mở Ứng Dụng
    _adService.loadAd();
  }

  void _nextToAddAB() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyAddAB(),
      ),
    );
  }

  //user
  final email = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Xin Chào, ".tr() + email.toString(),
            style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontFamily: "Urbanist",
                fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/image_apartment_building.jpg'),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hãy Chọn".tr(),
                      style: TextStyle(
                          color: Colors.white60,
                          fontSize: 25,
                          fontFamily: "Urbanist"),
                    ),
                    Text(
                      "Tòa Nhà Chung Cư / Nhà Trọ".tr(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontFamily: "Urbanist"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  thickness: 0.5,
                  color: Colors.white,
                ),
              ),
              EApartmentBuilding()
            ],
          ),
        ),
      ),
      drawer: MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextToAddAB,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add_home_work_outlined,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
