import 'package:apartment_management/Admin/components/deleteIcon.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class MyContainerApartmentDetails extends StatelessWidget {
  final String idApartmentFloor;
  final String idApartmentBuilding;
  final String idApartment;
  final String tenantId;
  final Function()? onTap;
  final String Email;
  final String Name;
  final String Sex;
  const MyContainerApartmentDetails({
    super.key,
    this.onTap,
    required this.Email,
    required this.Name,
    required this.Sex,
    required this.tenantId,
    required this.idApartmentFloor,
    required this.idApartmentBuilding,
    required this.idApartment,
  });

  @override
  Widget build(BuildContext context) {
    void deleteTenant() {
      // show a dialog box asking for confirmation before deleting the post
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Xóa Người thuê".tr()),
                content: const Text("Bạn có chắc chắn muốn xóa người thuê này?")
                    .tr(),
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
                              .doc(idApartmentBuilding)
                              .collection('Floor')
                              .doc(idApartmentFloor)
                              .collection('Apartment')
                              .doc(idApartment)
                              .collection('Tenant')
                              .doc(tenantId);

                          tenantRef.delete();
                          Navigator.pop(context);
                          print('Tenant deleted successfully');
                        } catch (e) {
                          print('Error deleting tenant: $e');
                        }
                      },
                      child: const Text("Chắc chắn").tr()),
                ],
              ));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: screenHeight * 0.2,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 149, 208, 238),
            borderRadius: BorderRadius.circular(8)),
        margin: EdgeInsets.only(
            left: screenWidth * 0.05,
            right: screenWidth * 0.05,
            top: screenHeight * 0.01),
        padding: EdgeInsets.symmetric(
            vertical: screenHeight * 0.02, horizontal: screenWidth * 0.05),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: AssetImage(
                  Sex.toString() == "1"
                      ? 'assets/avatars/avatar_boy.png'
                      : 'assets/avatars/avatar_female.png',
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    Email,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    Sex.toString() == "1" ? "Nam".tr() : "Nữ".tr(),
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
              IconDelete(
                ontap: deleteTenant,
              ),
            ]),
      ),
    );
  }
}
