import 'package:apartment_management/Auth/auth_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MySettingsPage extends StatefulWidget {
  @override
  State<MySettingsPage> createState() => _MySettingsPageState();
}

class _MySettingsPageState extends State<MySettingsPage> {
  final email = FirebaseAuth.instance.currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Chuyển đổi ngôn ngữ: ".tr(),
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    // Hàm xử lý khi nút Ngôn ngữ được nhấn
                    final currentLocale = context.locale.toString();
                    if (currentLocale == "en") {
                      context.setLocale(Locale("vi"));
                    } else {
                      context.setLocale(Locale("en"));
                    }
                  },
                  child: Text("Tiếng Việt").tr(),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Hàm xử lý khi nút Ngôn ngữ được nhấn
                    final currentLocale = context.locale.toString();
                    if (currentLocale == "en") {
                      context.setLocale(Locale("vi"));
                    } else {
                      context.setLocale(Locale("en"));
                    }
                  },
                  child: Text("Tiếng Anh").tr(),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                              title: Text("Xóa Tài Khoản Này?".tr()),
                              content: const Text(
                                      "Bạn có chắc chắn muốn xóa tài khoản này?")
                                  .tr(),
                              actions: [
                                // CANCEL BUTTON
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Hủy").tr()),

                                // DELETE BUTTON
                                TextButton(
                                    onPressed: () async {
                                      try {
                                        // Replace with the correct collection and document paths
                                        final deleteAccount =
                                            await FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(email);
                                        deleteAccount.delete();
                                        // Đăng xuất khỏi FirebaseAuth
                                        await FirebaseAuth.instance.signOut();
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => AuthPage()));
                                        print('Tenant deleted successfully');
                                      } catch (e) {
                                        print('Error deleting tenant: $e');
                                      }
                                    },
                                    child: const Text("Chắc chắn").tr()),
                              ],
                            ));
                  },
                  child: Text("Xóa tài khoản").tr(),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
