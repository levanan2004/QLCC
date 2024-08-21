import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyContainerServiceMonth extends StatelessWidget {
  final Function() onTap;
  final int idApartmentName;
  final int Month;
  const MyContainerServiceMonth({
    super.key,
    required this.idApartmentName,
    required this.Month,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Color.fromARGB(255, 149, 208, 238)),
          margin:
              const EdgeInsets.only(top: 25, left: 25, right: 5, bottom: 30),
          child: Text("Tháng ".tr() + Month.toString(),
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold))),
    );
  }
}
