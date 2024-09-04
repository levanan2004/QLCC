import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyContainerApartmentBuilding extends StatelessWidget {
  final Function()? onTap;
  final String apartmentBuildingName;
  final String own;
  final String phone;
  final String address;
  final String amount;
  final String amountFloor;
  final String code;
  const MyContainerApartmentBuilding({
    super.key,
    required this.apartmentBuildingName,
    required this.own,
    required this.phone,
    required this.address,
    required this.amount,
    required this.amountFloor,
    this.onTap,
    required this.code,
  });

  @override
  Widget build(BuildContext context) {
    double currentWidth = MediaQuery.of(context).size.width;
    double currentHeight = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            vertical: currentHeight * .05, horizontal: currentWidth * 0.1),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(currentWidth * 0.01),
            topRight: Radius.circular(currentWidth * 0.3),
            bottomLeft: Radius.circular(currentWidth * 0.01),
            bottomRight: Radius.circular(currentWidth * 0.01),
          ),
          gradient: LinearGradient(
            colors: [
              Colors.black26,
              Colors.grey,
              Colors.grey.shade400
            ], // Your color list
            begin: Alignment.topLeft, // Start point of the gradient
            end: Alignment.bottomRight, // End point of the gradient
          ),
        ),
        margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
        child: Column(
          children: [
            Row(
              children: [
                Icon(
                  Icons.apartment,
                  color: Colors.white60,
                  size: 40,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Tên: ".tr() + apartmentBuildingName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontFamily: "Urbanist",
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Icon(
                  Icons.home,
                  color: Colors.white60,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  address,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Urbanist"),
                )
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: [
                Icon(
                  Icons.person,
                  color: Colors.white60,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  own + "  -  " + phone,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Urbanist"),
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.code,
                  color: Colors.white60,
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  "Mã Giới Thiệu  -  ".tr() + code,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontFamily: "Urbanist"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
