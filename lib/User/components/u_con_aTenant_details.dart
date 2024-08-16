import 'package:flutter/material.dart';

class User_ConApartmentTenant extends StatelessWidget {
  final Function()? onTap;
  final Function()? onTapDelete;
  final Icon? icon;
  final Color? colorText;
  final String text;
  final Color? colorContainer;
  const User_ConApartmentTenant(
      {super.key,
      this.onTap,
      this.icon,
      this.colorText,
      required this.text,
      this.colorContainer,
      this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorContainer),
                    margin: const EdgeInsets.only(top: 25, left: 25, right: 5),
                    child: icon),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  text,
                  style: TextStyle(
                      color: colorText,
                      fontSize: 20,
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ));
  }
}
