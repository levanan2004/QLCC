import 'package:apartment_management/Admin/components/deleteIcon.dart';
import 'package:apartment_management/Admin/components/updateIcon.dart';
import 'package:flutter/material.dart';

class MyContainerServiceMonthTenant extends StatelessWidget {
  final Function() onTapDelete;
  final Function() onTapUpdate;
  final int idApartmentName;
  final bool Status;
  const MyContainerServiceMonthTenant(
      {super.key,
      required this.idApartmentName,
      required this.onTapDelete,
      required this.Status,
      required this.onTapUpdate});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Status == true ? Colors.green : Colors.red),
                margin: const EdgeInsets.only(top: 25, left: 25, right: 5),
                child: Icon(Icons.home)),
            Column(
              children: [
                SizedBox(
                  height: 25,
                ),
                IconDelete(
                  ontap: onTapDelete,
                ),
                SizedBox(
                  height: 5,
                ),
                IconUpdate(
                  ontap: onTapUpdate,
                  colorContainer: Colors.black,
                )
              ],
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Căn Hộ " + idApartmentName.toString(),
              style: TextStyle(
                  color: Status == true ? Colors.green : Colors.red,
                  fontSize: 20,
                  fontFamily: "Urbanist",
                  fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    ));
  }
}
