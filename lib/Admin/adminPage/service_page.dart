import 'package:apartment_management/Admin/adminPage/service_month_tenant.dart';
import 'package:flutter/material.dart';

class MyServicePage extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceName;
  const MyServicePage(
      {super.key,
      required this.idApartmentBuilding,
      required this.idServiceName,
      required this.idServiceAll});

  @override
  State<MyServicePage> createState() => _MyServicePageState();
}

class _MyServicePageState extends State<MyServicePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              widget.idServiceName,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold),
            ),
            leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 10,
                  child: Image.asset(
                    'assets/icons/icon_arrow.png',
                    color: Colors.black,
                  ),
                ))),
        body: MonthAparment(
          idApartmentBuilding: widget.idApartmentBuilding,
          idServiceAll: widget.idServiceAll,
          idServiceName: widget.idServiceName,
        ));
  }
}
