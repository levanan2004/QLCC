import 'package:apartment_management/Admin/feature_page/add_apartment_tenant.dart';
import 'package:apartment_management/Admin/page_components/pc_apartment_tenant.dart';
import 'package:flutter/material.dart';

class MyApartmentDetails extends StatefulWidget {
  final String idApartmentFloor;
  final String idApartmentBuilding;
  final String idApartment;
  final int apartmentName;

  const MyApartmentDetails({
    super.key,
    required this.idApartmentFloor,
    required this.idApartmentBuilding,
    required this.idApartment,
    required this.apartmentName,
  });

  @override
  State<MyApartmentDetails> createState() => _MyApartmentDetailsState();
}

class _MyApartmentDetailsState extends State<MyApartmentDetails> {
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
                          "Phòng " + widget.apartmentName.toString(),
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
                  height: 50,
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text("Thành viên: ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontFamily: "Urbanist")),
                  ],
                ),
                // trang này chứa code Layout và lấy dữ liệu Aparments từ Firebase.
                SBApartmentDetails(
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyAddTenantApartment(
                idApartmentBuilding: widget.idApartmentBuilding,
                idApartmentFloor: widget.idApartmentFloor,
                idApartment: widget.idApartment,
                idApartmentName: widget.apartmentName,
              ),
            ),
          );
        },
        backgroundColor: Color.fromARGB(255, 149, 208, 238),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
