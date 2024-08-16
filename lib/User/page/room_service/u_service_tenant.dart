import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/u_con_room_tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_SBServiceTenant extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceMonth;
  final String idServiceName;
  final int idApartmentName;
  const User_SBServiceTenant(
      {super.key,
      required this.idApartmentBuilding,
      required this.idServiceAll,
      required this.idServiceName,
      required this.idServiceMonth,
      required this.idApartmentName});

  @override
  State<User_SBServiceTenant> createState() => _User_SBServiceTenantState();
}

class _User_SBServiceTenantState extends State<User_SBServiceTenant> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ApartmentBuilding")
              .doc(widget.idApartmentBuilding)
              .collection("ServiceAll")
              .doc(widget.idServiceAll)
              .collection('Month')
              .doc(widget.idServiceMonth)
              .collection('Room')
              .where('ApartmentName', isEqualTo: widget.idApartmentName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the list of ApartmentBuilding
                    final indexOfST = snapshot.data!.docs[index];
                    return User_MyContainerServiceMonthTenant(
                      idApartmentName: indexOfST['ApartmentName'],
                      Money: indexOfST['Money'],
                      Unit: indexOfST['Unit'],
                      TimeStamp: indexOfST['TimeStamp'],
                      Status: indexOfST['Status'],
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error:${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Circular();
            } else {
              return Center(
                child: Text('Hãy thêm dữ liệu'),
              );
            }
          }),
    );
  }
}
