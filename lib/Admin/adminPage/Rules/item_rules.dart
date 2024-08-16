import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemPageRules extends StatefulWidget {
  final int number;
  final String content;
  final String fined;
  final String code;
  final Timestamp timeStamp;
  final Function()? onTap;
  final String role;
  const ItemPageRules({
    super.key,
    required this.content,
    required this.fined,
    required this.code,
    required this.timeStamp,
    this.onTap,
    required this.number,
    required this.role,
  });

  @override
  State<ItemPageRules> createState() => _ItemPageRulesState();
}

class _ItemPageRulesState extends State<ItemPageRules> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      elevation: 3.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Số thứ tự
            Text(
              '${widget.number}.',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                fontFamily: "Urbanist",
              ),
            ),
            const SizedBox(width: 10),

            // Nội dung và hình phạt
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.content,
                    style: const TextStyle(
                      fontSize: 18,
                      color: Colors.black87,
                      fontFamily: "Urbanist",
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Hình phạt: ' + widget.fined,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                      fontFamily: "Urbanist",
                    ),
                  ),
                  // Timestamp
                  Text(
                    '${widget.timeStamp.toDate().day}/${widget.timeStamp.toDate().month}/${widget.timeStamp.toDate().year}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontFamily: "Urbanist",
                    ),
                  ),
                ],
              ),
            ),

            if (widget.role == "1")
              GestureDetector(
                onTap: widget.onTap,
                child: Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              )
          ],
        ),
      ),
    );
  }
}
