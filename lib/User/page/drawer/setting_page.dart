import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MySettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cài đặt").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
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
      ),
    );
  }
}
