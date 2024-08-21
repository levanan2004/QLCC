import 'package:apartment_management/Admin/adminPage/service_page.dart';
import 'package:apartment_management/Admin/components/con_service.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SBService extends StatefulWidget {
  final String idApartmentBuilding;
  const SBService({super.key, required this.idApartmentBuilding});

  @override
  State<SBService> createState() => _SBServiceState();
}

class _SBServiceState extends State<SBService> {
  // Khi nhấp vào bất kỳ 1 trong các ServiceAll
  void _handleClickServiceAll(String documentIdApartmentBuilding,
      String documentIdService, String documentIdServiceName) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MyServicePage(
                  idApartmentBuilding: documentIdApartmentBuilding,
                  idServiceAll: documentIdService,
                  idServiceName: documentIdServiceName,
                )));
  }

  @override
  Widget build(BuildContext context) {
    // Hàm xóa Service
    void _deleteService(String documentIdService) {
      // show a dialog box asking for confirmation before deleting the post
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Xóa dịch vụ".tr()),
                content: Text("Bạn có chắc chắn muốn xóa dịch vụ này?").tr(),
                actions: [
                  // CANCEL BUTTON
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text("Hủy".tr())),

                  // DELETE BUTTON
                  TextButton(
                      onPressed: () async {
                        try {
                          // Replace with the correct collection and document paths

                          Navigator.pop(context);
                          final tenantRef = FirebaseFirestore.instance
                              .collection('ApartmentBuilding')
                              .doc(widget.idApartmentBuilding)
                              .collection('ServiceAll')
                              .doc(documentIdService);

                          await tenantRef.delete();
                          print('Service deleted successfully');
                        } catch (e) {
                          print('Error deleting Service: $e');
                        }
                      },
                      child: const Text("Vâng")),
                ],
              ));
    }

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
              return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the list of ApartmentBuilding
                    final indexOfSA = snapshot.data!.docs[index];
                    return MyContainerService(
                      onTapDelete: () => _deleteService(indexOfSA.id),
                      onTap: () => _handleClickServiceAll(
                          widget.idApartmentBuilding,
                          indexOfSA.id,
                          indexOfSA['ServiceName']),
                      data: indexOfSA['ServiceName'],
                      text: "",
                      colorText: Color.fromARGB(255, 149, 208, 238),
                      colorContainer: Color.fromARGB(255, 149, 208, 238),
                      icon: Icon(
                        Icons.shop_2,
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
