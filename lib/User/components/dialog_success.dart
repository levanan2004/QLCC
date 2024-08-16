import 'package:apartment_management/main.dart';
import 'package:flutter/material.dart';

class MyCustomDialog extends StatefulWidget {
  const MyCustomDialog({super.key});

  @override
  State<MyCustomDialog> createState() => _MyCustomDialogState();
}

class _MyCustomDialogState extends State<MyCustomDialog> {
  // Animation Logo
  bool _isAnimatedLogo = false;

  // InitState
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _isAnimatedLogo = true;
        Future.delayed(const Duration(milliseconds: 550), () {
          setState(() {
            Navigator.pop(context);
          });
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Container(
        height: 160,
        width: 500,
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: mq.width * .01,
              width: mq.width * .8,
              child: Container(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/icon_success.png',
                      width: 72,
                    ),
                    SizedBox(
                      height: 24,
                    ),
                    Text(
                      "Đã gửi đường liên kết sửa mật khẩu, hãy xem gmail của bạn",
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Color(0xFF1E232C),
                        fontSize: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            AnimatedPositioned(
              top: mq.height * .175,
              left: _isAnimatedLogo ? mq.width * .0 : -mq.width * .9,
              width: mq.width * .8,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: const Color.fromARGB(255, 126, 213, 129),
                height: 5,
              ),
            )
          ],
        ),
      ),
    );
  }
}
