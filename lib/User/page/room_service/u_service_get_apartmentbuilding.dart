import 'package:apartment_management/User/page/room_service/u_service_sb.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class User_ServiceGet_idApartmentBuilding extends StatefulWidget {
  const User_ServiceGet_idApartmentBuilding({super.key});

  @override
  State<User_ServiceGet_idApartmentBuilding> createState() =>
      _User_ServiceGet_idApartmentBuildingState();
}

class _User_ServiceGet_idApartmentBuildingState
    extends State<User_ServiceGet_idApartmentBuilding> {
  final userEmail = FirebaseAuth.instance.currentUser!.email;

  Future<Map<String, dynamic>> getApartmentInfo() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('Users')
        .where('email', isEqualTo: userEmail)
        .get();

    if (userDoc.docs.isNotEmpty) {
      final data = userDoc.docs.first.data();
      return {
        'idApartmentName': data['idApartmentName'].toString(),
        'idApartmentBuilding': data['idApartmentBuilding'].toString(),
      };
    } else {
      return {'error': 'Không tìm thấy dữ liệu người dùng'};
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: getApartmentInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Lỗi: ${snapshot.error}');
        } else {
          final data = snapshot.data!;
          return User_Service_SB(
            idApartmentBuilding: data['idApartmentBuilding'].toString(),
            idApartmentName: int.parse(data['idApartmentName']),
          );
        }
      },
    );
  }
}
