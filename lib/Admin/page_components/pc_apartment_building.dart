import 'package:apartment_management/Admin/adminPage/floor_service/floor_service.dart';
import 'package:apartment_management/Admin/components/con_apartmentBuilding.dart';
import 'package:apartment_management/Admin/feature_page/add_apartment_building.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EApartmentBuilding extends StatefulWidget {
  const EApartmentBuilding({super.key});

  @override
  State<EApartmentBuilding> createState() => _EApartmentBuildingState();
}

class _EApartmentBuildingState extends State<EApartmentBuilding> {
  // Hàm kiểm tra 'ApartmentBuildingCode' của User có trùng với 'CODE' của ApartmentBuilding không
  Future<List<DocumentSnapshot>> _fetchApartmentBuildings() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Không có người dùng nào đăng nhập');
    }

    // lấy user CODE collection
    final userCodeSnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .doc(user.email)
        .collection('CODE')
        .get();
    // lặp qua từng Collection('CODE') của Users để lấy 'ApartmentBuildingCode'
    final userBuildingCodes = userCodeSnapshot.docs
        .map((doc) => doc['ApartmentBuildingCode'] as String)
        .toList();

    // Get ApartmentBuilding documents that match user codes
    final apartmentBuildingSnapshot = await FirebaseFirestore.instance
        .collection('ApartmentBuilding')
        .where('CODE', whereIn: userBuildingCodes)
        .get();

    return apartmentBuildingSnapshot.docs;
  }

  @override
  void initState() {
    super.initState();
    _fetchApartmentBuildings();
  }

  void _navigateToDetailsPage(BuildContext context, String documentId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyFloorService(idApartmentBuilding: documentId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: FutureBuilder<List<DocumentSnapshot>>(
        future: _fetchApartmentBuildings(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.isEmpty) {
              return AlertDialog(
                content: Text(
                  'Hãy thêm Toà Nhà Chung Cư hay Nhà Trọ để bắt đầu quản lý',
                  style: TextStyle(
                    fontFamily: 'Urbanist',
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyAddAB(),
                        ),
                      );
                    },
                  ),
                ],
              );
            } else {
              final apartmentBuildings = snapshot.data!;
              return ListView.builder(
                itemCount: apartmentBuildings.length,
                itemBuilder: (context, index) {
                  final apartmentBuilding = apartmentBuildings[index];
                  return MyContainerApartmentBuilding(
                    onTap: () =>
                        _navigateToDetailsPage(context, apartmentBuilding.id),
                    apartmentBuildingName:
                        apartmentBuilding['ApartmentBuildingName'],
                    own: apartmentBuilding['Own'],
                    phone: apartmentBuilding['Phone'],
                    address: apartmentBuilding['City'],
                    amount: apartmentBuilding['Amount'],
                    amountFloor: apartmentBuilding['AmountFloor'],
                    code: apartmentBuilding['CODE'],
                  );
                },
              );
            }
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            return Center(
              child: Text(
                'Hãy tạo 1 Tòa nhà chung cư / Nhà trọ của riêng',
                style: TextStyle(color: Colors.white),
              ),
            );
          }
        },
      ),
    );
  }
}
