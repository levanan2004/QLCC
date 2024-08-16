import 'package:flutter/material.dart';

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key,
      required this.text,
      required this.sectionName,
      this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section
          Row(
            children: [
              // SectionName
              Text(
                sectionName,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "Urbanist",
                ),
              ),
              const Spacer(),
              // Edit Button
              onPressed != null
                  ? IconButton(
                      onPressed: onPressed,
                      icon: Icon(
                        Icons.settings,
                        color: Colors.grey[400],
                      ))
                  : IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.star,
                        color: Colors.grey[400],
                      ))
            ],
          ),

          // Text
          Text(text,
              style: TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontFamily: "Urbanist",
              )),
        ],
      ),
    );
  }
}
