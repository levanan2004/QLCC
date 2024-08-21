import 'package:apartment_management/Admin/adminPage/apartment_tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyButtonSearchToApartmentDetails extends StatefulWidget {
  final String idApartmentBuilding;
  final String idFloor;
  final int ApartmentName;
  final Map<String, dynamic> apartment;
  const MyButtonSearchToApartmentDetails(
      {super.key,
      required this.idApartmentBuilding,
      required this.idFloor,
      required this.ApartmentName,
      required this.apartment});

  @override
  State<MyButtonSearchToApartmentDetails> createState() =>
      _MyButtonSearchToApartmentDetailsState();
}

class _MyButtonSearchToApartmentDetailsState
    extends State<MyButtonSearchToApartmentDetails> {
  // Tạo 1 String chứ IdApartment
  String? apartmentId;

  // Hàm tìm kiếm dữ liệu IdApartmemt
  Future<void> _searchIdApartment() async {
    try {
      QuerySnapshot<Map<String, dynamic>> floorsSnapshot =
          await FirebaseFirestore.instance
              .collection('ApartmentBuilding')
              .doc(widget.idApartmentBuilding)
              .collection('Floor')
              .doc(widget.idFloor)
              .collection('Apartment')
              .where('ApartmentName', isEqualTo: widget.ApartmentName)
              .get();

      if (floorsSnapshot.docs.isNotEmpty) {
        setState(() {
          apartmentId = floorsSnapshot.docs.first.id;
        });
      } else {
        setState(() {
          apartmentId = null;
        });
      }
    } catch (e) {
      print("Error fetching apartment ID: $e");
      setState(() {
        apartmentId = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await _searchIdApartment();
        if (apartmentId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyApartmentDetails(
                idApartmentBuilding: widget.idApartmentBuilding,
                idApartmentFloor: widget.idFloor,
                idApartment: apartmentId!,
                apartmentName: widget.ApartmentName,
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Không tìm thấy phòng này").tr()),
          );
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              topRight: Radius.circular(30),
              bottomRight: Radius.circular(10),
              topLeft: Radius.circular(10)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 149, 208, 238),
                      borderRadius: BorderRadius.circular(10)),
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Phòng ".tr() + widget.ApartmentName.toString(),
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 25,
                      fontFamily: "Urbanist"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
