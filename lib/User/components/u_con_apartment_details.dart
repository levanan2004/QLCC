import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class User_MyContainerApartmentDetails extends StatelessWidget {
  final String idApartmentFloor;
  final String idApartmentBuilding;
  final String idApartment;
  final String tenantId;
  final Function()? onTap;
  final String Email;
  final String Name;
  final String Sex;
  const User_MyContainerApartmentDetails({
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
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            backgroundImage: AssetImage(
              Sex.toString() == "1"
                  ? 'assets/avatars/avatar_boy.png'
                  : 'assets/avatars/avatar_female.png',
            ),
          ),
          SizedBox(
            width: 50,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Email: " + Email,
                  style:
                      TextStyle(color: Colors.white, fontFamily: "Urbanist")),
              Row(
                children: [
                  Text("Tên: ".tr() + Name,
                      style: TextStyle(
                          color: Colors.white, fontFamily: "Urbanist")),
                  SizedBox(
                    width: 10,
                  ),
                  Text(Sex.toString() == "1" ? "Nam".tr() : "Nữ".tr(),
                      style: TextStyle(
                          color: Colors.black54, fontFamily: "Urbanist")),
                ],
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
