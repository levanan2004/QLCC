import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class itemPageMessage extends StatelessWidget {
  final String content;
  final String userEmail;
  final Timestamp timeStamp;
  final bool
      isCurrentUser; // To distinguish between the user's and other messages

  const itemPageMessage({
    super.key,
    required this.content,
    required this.userEmail,
    required this.timeStamp,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi thời gian
    // String formattedDate = DateFormat('dd/MM/yyyy').format(timeStamp.toDate());
    String formattedHour = DateFormat('HH:mm').format(timeStamp.toDate());
    // chuyển đổi email lấy tên
    String username = userEmail.split('@')[0];
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            decoration: BoxDecoration(
              color: isCurrentUser
                  ? Color.fromARGB(255, 12, 233, 170)
                  : Colors.grey[300],
              borderRadius: isCurrentUser
                  ? const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0),
                    )
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                      bottomRight: Radius.circular(12.0),
                    ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!isCurrentUser)
                  Text(
                    username,
                    style: TextStyle(
                        color: isCurrentUser
                            ? Colors.black87
                            : Color.fromARGB(255, 83, 228, 167),
                        fontSize: isCurrentUser ? 12 : 16,
                        fontFamily: "Urbanist",
                        fontWeight: isCurrentUser ? null : FontWeight.bold),
                  ),
                const SizedBox(height: 5),
                Text(
                  content,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: "Urbanist",
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  formattedHour,
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 12,
                    fontFamily: "Urbanist",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
