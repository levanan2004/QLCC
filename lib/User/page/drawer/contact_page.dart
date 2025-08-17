import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ContractPage extends StatefulWidget {
  const ContractPage({super.key});

  @override
  State<ContractPage> createState() => _ContractPageState();
}

class _ContractPageState extends State<ContractPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liên hệ với chúng tôi").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text("Đóng góp ý kiến và nhận phản hồi qua email".tr(),
                      style: TextStyle(
                          fontFamily: "Urbanist",
                          fontSize: 18,
                          color: Colors.black)),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.email, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  "Email: laptrinh03022024@gmail.com",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: const [
                Icon(Icons.tiktok, color: Colors.black),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'TikTok: @uocmasterflutter',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
