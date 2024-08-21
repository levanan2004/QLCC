import 'package:apartment_management/Admin/components/con_floor_room.dart';
import 'package:apartment_management/Admin/adminPage/apartment_tenant.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SBApartment extends StatefulWidget {
  final String idApartmentBuilding;
  final String idApartmentFloor;
  const SBApartment(
      {super.key,
      required this.idApartmentBuilding,
      required this.idApartmentFloor});

  @override
  State<SBApartment> createState() => _SBApartmentState();
}

class _SBApartmentState extends State<SBApartment> {
  // Khi nhấp vào bất kỳ 1 trong các Apartment
  void _handleClickAparment(
      String documentIdApartmentBuilding,
      String documentIdiApartmentFloor,
      String documentIdApartment,
      int apartmentName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyApartmentDetails(
                  idApartmentBuilding: documentIdApartmentBuilding,
                  idApartmentFloor: documentIdiApartmentFloor,
                  idApartment: documentIdApartment,
                  apartmentName: apartmentName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // Hàm xóa Apartment (Room)
    void _deleteApartment(String documentApartment) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Xóa Phòng".tr()),
                content: Text("Bạn có chắc chắn muốn xóa phòng này?").tr(),
                actions: [
                  // CANCEL BUTTON
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Hủy").tr()),

                  // DELETE BUTTON
                  TextButton(
                      onPressed: () async {
                        try {
                          // Replace with the correct collection and document paths
                          final tenantRef = FirebaseFirestore.instance
                              .collection('ApartmentBuilding')
                              .doc(widget.idApartmentBuilding)
                              .collection('Floor')
                              .doc(widget.idApartmentFloor)
                              .collection('Apartment')
                              .doc(documentApartment);

                          await tenantRef.delete();
                          print('Apartment deleted successfully');
                        } catch (e) {
                          print('Error deleting Apartment: $e');
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Chắc Chắn").tr()),
                ],
              ));
    }

    return SizedBox(
      height: 200,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ApartmentBuilding")
              .doc(widget.idApartmentBuilding)
              .collection("Floor")
              .doc(widget.idApartmentFloor)
              .collection("Apartment")
              .orderBy("ApartmentName", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the list of ApartmentBuilding
                    final indexOfA = snapshot.data!.docs[index];
                    final apartmentData = indexOfA.data();
                    final status = apartmentData['Status'] as bool;

                    Color colorIconAndText = status ? Colors.green : Colors.red;
                    return MyContainerFloorAndRoom(
                      onTapDelete: () => _deleteApartment(indexOfA.id),
                      onTap: () => _handleClickAparment(
                          widget.idApartmentBuilding,
                          widget.idApartmentFloor,
                          indexOfA.id,
                          indexOfA['ApartmentName']),
                      data: indexOfA['ApartmentName'],
                      text: "Phòng ".tr(),
                      colorText: colorIconAndText,
                      colorContainer: Colors.black12,
                      icon: Icon(
                        Icons.home,
                        size: 30,
                        color: colorIconAndText,
                      ),
                    );
                  });
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
