import 'package:apartment_management/Admin/components/deleteIcon.dart';
import 'package:flutter/material.dart';

class MyContainerService extends StatelessWidget {
  final Function()? onTap;
  final Function() onTapDelete;
  final Icon? icon;
  final Color? colorText;
  final String data;
  final String text;
  final Color? colorContainer;
  const MyContainerService(
      {super.key,
      this.onTap,
      this.icon,
      this.colorText,
      required this.data,
      required this.text,
      this.colorContainer,
      required this.onTapDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
          onTap: onTap,
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                      padding: EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorContainer),
                      margin:
                          const EdgeInsets.only(top: 25, left: 25, right: 5),
                      child: icon),
                  Column(
                    children: [
                      IconDelete(
                        ontap: onTapDelete,
                      )
                    ],
                  )
                ],
              ),
              Text(
                text + data.toString(),
                style: TextStyle(
                    color: colorText,
                    fontSize: 20,
                    fontFamily: "Urbanist",
                    fontWeight: FontWeight.bold),
              )
            ],
          )),
    );
  }
}
