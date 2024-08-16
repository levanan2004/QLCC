import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class itemPageNotification extends StatelessWidget {
  final String title;
  final String content;
  final bool status;
  final String userEmail;
  final Timestamp timeStamp;
  final Function()? onTap;
  const itemPageNotification(
      {super.key,
      required this.title,
      required this.content,
      required this.status,
      required this.userEmail,
      required this.timeStamp,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 3,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: Colors.grey.withOpacity(0.2),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (status == false)
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 50,
                    height: 30,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(
                        child: Text(
                      'Mới',
                      style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Urbanist",
                          color: Colors.white),
                    )),
                  ),
                ],
              ),
            SizedBox(
              height: 10,
            ),
            Text(
              title,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: status == true ? Colors.grey : Colors.black,
              ),
            ),
            SizedBox(height: 15),
            Text(
              content,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: status == true ? Colors.grey : Colors.black87,
                height: 1.5, // tăng khoảng cách dòng
              ),
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Email: $userEmail',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: status == true ? Colors.grey : Colors.blue,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                Text(
                  'Thời gian: ${DateFormat.yMMMd().format(timeStamp.toDate())}',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    color: status == true ? Colors.grey : Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
