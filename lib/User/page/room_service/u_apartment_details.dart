import 'package:apartment_management/User/page_component/u_pc_apartment_details.dart';
import 'package:apartment_management/admob/banner.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class User_MyApartmentDetails extends StatefulWidget {
  final String idApartmentFloor;
  final String idApartmentBuilding;
  final String idApartment;
  final int apartmentName;

  const User_MyApartmentDetails({
    super.key,
    required this.idApartmentFloor,
    required this.idApartmentBuilding,
    required this.idApartment,
    required this.apartmentName,
  });

  @override
  State<User_MyApartmentDetails> createState() =>
      _User_MyApartmentDetailsState();
}

class _User_MyApartmentDetailsState extends State<User_MyApartmentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/images/image_tenant.jpg'),
                      fit: BoxFit.cover)),
              child: Container(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.bottomRight,
                        colors: [
                      Colors.black.withOpacity(.8),
                      Colors.black.withOpacity(.3)
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.white),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              height: 40,
                              child: Image.asset(
                                'assets/icons/icon_arrow.png',
                                color: Colors.white,
                              ),
                            )),
                        SizedBox(
                          width: 80,
                        ),
                        Text(
                          "Phòng ".tr() + widget.apartmentName.toString(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            // Member
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // quảng cáo banner
                    BannerAdWidget()
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text("Thành Viên: ".tr(),
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontFamily: "Urbanist")),
                  ],
                ),
                // trang này chứa code Layout và lấy dữ liệu Aparments từ Firebase.
                User_SBApartmentDetails(
                  idApartmentBuilding: widget.idApartmentBuilding,
                  idApartmentFloor: widget.idApartmentFloor,
                  idApartment: widget.idApartment,
                ),
              ],
            ),
            // Service
          ],
        ),
      ),
    );
  }
}
