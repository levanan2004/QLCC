import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ItemPageViolate extends StatefulWidget {
  final String title;
  final String content;
  final bool status;
  final String fined;
  final String userEmail;
  final Timestamp timeStamp;
  final Function()? onTap;
  const ItemPageViolate(
      {super.key,
      required this.title,
      required this.content,
      required this.status,
      required this.userEmail,
      required this.timeStamp,
      this.onTap,
      required this.fined});

  @override
  State<ItemPageViolate> createState() => _ItemPageViolateState();
}

class _ItemPageViolateState extends State<ItemPageViolate> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Trạng thái: ',
                style: TextStyle(
                    fontSize: 18, fontFamily: "Urbanist", color: Colors.black),
              ),
              SizedBox(
                width: 10,
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                      color: widget.status == true ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: Text(
                    widget.status == true ? "Đã xử lý" : 'Chưa xử lý',
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Urbanist",
                        color: Colors.white),
                  )),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Tiêu đề: ' + widget.title,
            maxLines: 2,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Nội dung: ' + widget.content,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
              height: 1.5, // tăng khoảng cách dòng
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Hình phạt: ' + widget.fined,
            style: TextStyle(
              fontSize: 16,
              color: widget.status == true ? Colors.black : Colors.red,
              height: 1.5, // tăng khoảng cách dòng
            ),
          ),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Email: ${widget.userEmail}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.blue,
                  fontStyle: FontStyle.italic,
                ),
              ),
              Text(
                'Thời gian: ${widget.timeStamp.toDate().day}/${widget.timeStamp.toDate().month}/${widget.timeStamp.toDate().year}',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
