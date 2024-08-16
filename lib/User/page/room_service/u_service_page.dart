import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/page/room_service/u_month_tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class User_MyServicePage extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceName;
  final int idApartmentName;
  const User_MyServicePage(
      {super.key,
      required this.idApartmentBuilding,
      required this.idServiceName,
      required this.idServiceAll,
      required this.idApartmentName});

  @override
  State<User_MyServicePage> createState() => _User_MyServicePageState();
}

class _User_MyServicePageState extends State<User_MyServicePage> {
  String idServiceMonth = "";
  Future<String> _fetchDataServiceMonth() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("ApartmentBuilding")
          .doc(widget.idApartmentBuilding)
          .collection("ServiceAll")
          .doc(widget.idServiceAll)
          .collection('Month')
          .orderBy('Month', descending: false) // Order by Month ascending
          .limit(1) // Get only the first document
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs.first;
        setState(() {
          idServiceMonth = document.id;
        });
        return idServiceMonth;
      } else {
        // No documents found, throw an error
        throw Exception("No service month found");
      }
    } catch (e) {
      print("Error fetching initial month: $e");
      return "";
    }
  }

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
      body: FutureBuilder<String>(
        future: _fetchDataServiceMonth(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return User_MonthRoom(
              idApartmentBuilding: widget.idApartmentBuilding,
              idServiceAll: widget.idServiceAll,
              idServiceMonth:
                  snapshot.data!, // Truyền idServiceMonth vào MonthAparment
              idServiceName: widget.idServiceName,
              idApartmentName: widget.idApartmentName,
            ); // Hiển thị
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}'); // Hiển thị error
          } else {
            return Circular();
          }
        },
      ),
    );
  }
}
