import 'package:apartment_management/Admin/adminPage/room_page.dart';
import 'package:apartment_management/Admin/components/con_floor_room.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SBFloor extends StatefulWidget {
  final String idApartmentBuilding;
  const SBFloor({super.key, required this.idApartmentBuilding});

  @override
  State<SBFloor> createState() => _SBFloorState();
}

class _SBFloorState extends State<SBFloor> {
  // Khi nhấp vào bất kỳ 1 trong các Apartment
  void _handleClickFloor(String documentIdApartmentBuilding,
      String documentIdFloor, int documentFloor) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyRoomPage(
                  idApartmentBuilding: documentIdApartmentBuilding,
                  idFloor: documentIdFloor,
                  Floor: documentFloor,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // Hàm xóa Floor
    void _deleteFloor(String documentFloor) {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Xóa Tầng".tr()),
                content: Text("Bạn có chắc chắn rằng muốn xóa tầng này?").tr(),
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
                              .doc(documentFloor);

                          await tenantRef.delete();
                          print('Xóa Tầng thành công');
                        } catch (e) {
                          print('Error deleting Floor: $e');
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Chắc Chắn").tr()),
                ],
              ));
    }

    return SizedBox(
      height: 150,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ApartmentBuilding")
              .doc(widget.idApartmentBuilding)
              .collection("Floor")
              .orderBy("Floor", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the list of ApartmentBuilding
                    final indexOfA = snapshot.data!.docs[index];
                    return MyContainerFloorAndRoom(
                      onTapDelete: () => _deleteFloor(indexOfA.id),
                      onTap: () => _handleClickFloor(widget.idApartmentBuilding,
                          indexOfA.id, indexOfA['Floor']),
                      data: indexOfA['Floor'],
                      text: "Tầng ".tr(),
                      colorText: Color.fromARGB(255, 163, 214, 184),
                      colorContainer: Color.fromARGB(255, 163, 214, 184),
                      icon: Icon(
                        Icons.elevator,
                        size: 30,
                        color: Colors.white,
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
