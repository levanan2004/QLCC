import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class PrivacyPolicyPage extends StatefulWidget {
  @override
  _PrivacyPolicyPageState createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  bool _isAgreed = false;

  void _onAgreeChanged(bool? newValue) {
    setState(() {
      _isAgreed = newValue ?? false;
    });
  }

  void _onAgreeButtonPressed() {
    if (_isAgreed) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chính sách bảo mật").tr(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  "privacy_policy_content".tr(),
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            ),
            const SizedBox(
                height:
                    16.0), // Add space between content and agreement checkbox
            Row(
              children: [
                Checkbox(
                  value: _isAgreed,
                  onChanged: _onAgreeChanged,
                ),
                Expanded(
                  child: Text(
                    "Tôi đồng ý với chính sách bảo mật".tr(),
                    style: TextStyle(fontSize: 16.0),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height:
                    16.0), // Add space between agreement checkbox and button
            ElevatedButton(
              onPressed: _isAgreed ? _onAgreeButtonPressed : null,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Text("Đồng ý & Tiếp tục").tr(),
            ),
          ],
        ),
      ),
    );
  }
}
