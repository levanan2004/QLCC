import 'package:apartment_management/User/page/drawer/account_page.dart';
import 'package:apartment_management/User/page/drawer/contact_page.dart';
import 'package:apartment_management/User/page/drawer/message/page_message.dart';
import 'package:apartment_management/User/page/drawer/setting_page.dart';
import 'package:apartment_management/admob/interstitial.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
// sign out
  void signOut() {
    FirebaseAuth.instance.signOut();
  }

  String? email = FirebaseAuth.instance.currentUser!.email;
  // <quảng cáo Trung gian(Interstitial)>
  final InterstitialAdService _interstitialAdService = InterstitialAdService();
  void _showInterstitialAd() {
    _interstitialAdService.showInterstitialAd();
  }
  // </quảng cáo Trung gian(Interstitial)>

  @override
  void initState() {
    super.initState();
    // Khởi tạo Trung gian(Interstitial) khi vừa sang trang này
    _interstitialAdService.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer header
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/icons/icon_main.png'),
                  radius: 40,
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    "Xin chào,\n".tr() + email!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Urbanist",
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: Icon(Icons.home),
                  title: Text(
                    "Trang Chủ".tr(),
                    style: TextStyle(
                        fontFamily: "Urbanist",
                        fontSize: 20,
                        color: Colors.black),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    // Navigate to home page
                  },
                ),
                ListTile(
                  leading: Icon(Icons.message),
                  title: Text("Tin Nhắn".tr(),
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 20,
                          color: Colors.black)),
                  onTap: () {
                    {
                      _showInterstitialAd();

                      Navigator.push(context,
                          MaterialPageRoute(builder: (_) => MyMessage()));
                    }
                  },
                ),
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text("Tài Khoản".tr(),
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 20,
                          color: Colors.black)),
                  onTap: () {
                    _showInterstitialAd();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MyAccount()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text("Cài đặt".tr(),
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 20,
                          color: Colors.black)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => MySettingsPage()));
                  },
                ),
                // Thông tin liên hệ
                ListTile(
                  leading: Icon(Icons.perm_device_information_outlined),
                  title: Text("Thông Tin Liên Hệ".tr(),
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 20,
                          color: Colors.black)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ContractPage()));
                  },
                ),
              ],
            ),
          ),
          // Sign out button
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Đăng Xuất".tr(),
                style: TextStyle(
                    fontFamily: "Urbanist", fontSize: 20, color: Colors.black)),
            onTap: signOut,
          ),
        ],
      ),
    );
  }
}
