import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/u_con_service.dart';
import 'package:apartment_management/User/page/room_service/u_service_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_Service_SB extends StatefulWidget {
  final String idApartmentBuilding;
  final int idApartmentName;
  const User_Service_SB({
    super.key,
    required this.idApartmentBuilding,
    required this.idApartmentName,
  });

  @override
  State<User_Service_SB> createState() => _User_Service_SBState();
}

class _User_Service_SBState extends State<User_Service_SB> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  // Khi nhấp vào bất kỳ 1 trong các Apartment
  void _handleClickServiceAll(String documentIdApartmentBuilding,
      String documentIdService, String documentIdServiceName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => User_MyServicePage(
                  idApartmentBuilding: documentIdApartmentBuilding,
                  idServiceAll: documentIdService,
                  idServiceName: documentIdServiceName,
                  idApartmentName: widget.idApartmentName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ApartmentBuilding")
              .doc(widget.idApartmentBuilding)
              .collection("ServiceAll")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                // No data found, display message
                return Center(
                  child: Text("Hãy báo chủ căn hộ thêm dịch vụ cho bạn".tr()),
                );
              } else {
                return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      //lấy danh sách ApartmentBuilding
                      final indexOfSA = snapshot.data!.docs[index];
                      return User_MyContainerService(
                        onTap: () => _handleClickServiceAll(
                            widget.idApartmentBuilding,
                            indexOfSA.id,
                            indexOfSA['ServiceName']),
                        text: indexOfSA['ServiceName'],
                        colorText: Color.fromARGB(255, 149, 208, 238),
                        colorContainer: Color.fromARGB(255, 149, 208, 238),
                        icon: Icon(
                          Icons.shop_2,
                          size: 30,
                          color: Colors.white,
                        ),
                      );
                    });
              }
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error:${snapshot.error}'),
              );
            }
            return Center(
              child: Circular(),
            );
          }),
    );
  }
}
