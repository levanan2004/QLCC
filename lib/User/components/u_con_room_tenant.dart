import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class User_MyContainerServiceMonthTenant extends StatefulWidget {
  final int idApartmentName;
  final int Money;
  final int Unit;
  final Timestamp TimeStamp;
  final bool Status;
  const User_MyContainerServiceMonthTenant({
    super.key,
    required this.idApartmentName,
    required this.Status,
    required this.Money,
    required this.TimeStamp,
    required this.Unit,
  });

  @override
  State<User_MyContainerServiceMonthTenant> createState() =>
      _User_MyContainerServiceMonthTenantState();
}

class _User_MyContainerServiceMonthTenantState
    extends State<User_MyContainerServiceMonthTenant> {
  @override
  Widget build(BuildContext context) {
    DateTime dateTime = widget.TimeStamp.toDate();
    String formattedDate = DateFormat('dd MMMM yyyy').format(dateTime);
    return Container(
      padding: EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: widget.Status == true
              ? Color.fromARGB(255, 143, 235, 189)
              : Color.fromARGB(255, 235, 123, 115)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Căn Hộ: ${widget.idApartmentName}',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Tiền: ${widget.Money} VNĐ',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Đơn vị sử dụng: ${widget.Unit}/kWh',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Ngày Đăng: $formattedDate',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Trạng thái: ${widget.Status ? "Đã đóng" : "Chưa đóng"}',
              style: TextStyle(
                  color: widget.Status == true
                      ? Colors.black
                      : Color.fromARGB(255, 226, 218, 53),
                  fontSize: widget.Status == true ? 18 : 22,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
