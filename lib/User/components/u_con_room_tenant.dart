import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

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
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(50),
            topRight: Radius.circular(150),
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50)),
        color: widget.Status == true
            ? Color.fromARGB(255, 143, 235, 189)
            : Color.fromARGB(255, 244, 86, 74),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 149, 208, 238)
                .withOpacity(0.8), // Màu bóng, có thể thay đổi
            spreadRadius: 5, // Độ lan tỏa của bóng
            blurRadius: 10, // Độ mờ của bóng
            offset: Offset(0, 4), // Vị trí của bóng so với item
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Phòng: ".tr() + widget.idApartmentName.toString(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Urbanist",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Tiền: ".tr() + widget.Money.toString() + " VNĐ".tr(),
              style: TextStyle(
                  color: Colors.black,
                  fontFamily: "Urbanist",
                  fontSize: 18,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Đơn vị sử dụng: ".tr() + widget.Unit.toString() + " /kWh",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Ngày Đăng: ".tr() + formattedDate,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                "Trạng thái: ".tr(),
                style: TextStyle(
                    color: Colors.black,
                    fontSize: widget.Status == true ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist"),
              ),
              Text('${widget.Status ? "Đã đóng".tr() : "Chưa đóng".tr()}',
                  style: TextStyle(
                    color: widget.Status == true
                        ? Colors.black
                        : Color.fromARGB(255, 226, 218, 53),
                    fontSize: widget.Status == true ? 18 : 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist",
                    shadows: [
                      Shadow(
                        color: Color.fromARGB(255, 12, 233, 170)
                            .withOpacity(0.3), // Màu sắc của bóng
                        offset:
                            Offset(2.0, 2.0), // Vị trí của bóng so với văn bản
                        blurRadius: 4.0, // Độ mờ của bóng
                      ),
                    ],
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
