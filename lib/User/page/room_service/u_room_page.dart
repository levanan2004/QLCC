import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/components/u_con_aTenant_details.dart';
import 'package:apartment_management/User/page/room_service/u_apartment_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_SBRoomTenant extends StatefulWidget {
  const User_SBRoomTenant({
    super.key,
  });

  @override
  State<User_SBRoomTenant> createState() => _User_SBRoomTenantState();
}

class _User_SBRoomTenantState extends State<User_SBRoomTenant> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  // Khi nhấp vào bất kỳ 1 trong các Apartment
  void _handleClickRoom(
      String documentIdApartmentBuilding,
      String documentIdFloor,
      String documentIdApartment,
      int documentApartmentName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => User_MyApartmentDetails(
                  idApartmentBuilding: documentIdApartmentBuilding,
                  idApartmentFloor: documentIdFloor,
                  idApartment: documentIdApartment,
                  apartmentName: documentApartmentName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .where('email', isEqualTo: userEmail)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.isEmpty) {
                // No data found, display message
                return Center(
                  child: Text(
                      'User đã có dữ liệu mặc định nhưng chưa được Chủ thêm vào phòng'),
                );
              } else {
                // Data available, display rooms or message
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final indexOfRT = snapshot.data!.docs[index];
                    if (indexOfRT['idApartmentBuilding'] == "a") {
                      return Row(
                        children: [
                          SizedBox(
                            width: 50,
                          ),
                          Center(
                              child: Text(
                                  'Hãy báo với chủ hộ thêm cho bạn vào phòng')),
                        ],
                      );
                    } else {
                      return User_ConApartmentTenant(
                        onTap: () => _handleClickRoom(
                          indexOfRT['idApartmentBuilding'],
                          indexOfRT['idApartmentFloor'],
                          indexOfRT['idApartment'],
                          indexOfRT['idApartmentName'],
                        ),
                        text: "Phòng",
                        colorText: Color.fromARGB(255, 163, 214, 184),
                        colorContainer: Color.fromARGB(255, 163, 214, 184),
                        icon: Icon(
                          Icons.elevator,
                          size: 30,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                );
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
