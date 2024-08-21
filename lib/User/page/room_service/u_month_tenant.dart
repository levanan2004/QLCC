import 'package:apartment_management/Admin/components/con_month_tenant.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:apartment_management/User/page/room_service/u_service_tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class User_MonthRoom extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceName;
  final String idServiceMonth;
  final int idApartmentName;
  const User_MonthRoom({
    super.key,
    required this.idApartmentBuilding,
    required this.idServiceAll,
    required this.idServiceName,
    required this.idServiceMonth,
    required this.idApartmentName,
  });

  @override
  State<User_MonthRoom> createState() => _User_MonthRoomState();
}

class _User_MonthRoomState extends State<User_MonthRoom> {
  // Xử lý việc trả về idServiceMonth mỗi lần click vào mục tháng
  String idServiceMonth = "";
  int MonthOld = 0;
  void _handleClickReturnMonth(String documentMonth, int MonthNew) {
    setState(() {
      idServiceMonth = documentMonth;
      MonthOld = MonthNew;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchInitialMonth();
  }

  Future<void> _fetchInitialMonth() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection("ApartmentBuilding")
          .doc(widget.idApartmentBuilding)
          .collection("ServiceAll")
          .doc(widget.idServiceAll)
          .collection('Month')
          .orderBy('Month', descending: false) // Order by Month ascending
          .limit(1) // Get only the first document
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot document = snapshot.docs.first;
        setState(() {
          idServiceMonth = document.id;
          MonthOld = document['Month'];
        });
        return;
      }
    } catch (e) {
      print("Error fetching initial month: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 120,
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection("ApartmentBuilding")
                            .doc(widget.idApartmentBuilding)
                            .collection("ServiceAll")
                            .doc(widget.idServiceAll)
                            .collection('Month')
                            .orderBy('Month', descending: false)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (idServiceMonth.isEmpty) {
                              // Handle initial empty state
                              return Center(
                                  child: Text(
                                      "Bạn chưa được thêm dịch vụ tháng này"
                                          .tr()));
                            } else {
                              return ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, index) {
                                    //get the list of ApartmentBuilding
                                    final indexOfSM =
                                        snapshot.data!.docs[index];
                                    return MyContainerServiceMonth(
                                      onTap: () => _handleClickReturnMonth(
                                          indexOfSM.id, indexOfSM['Month']),
                                      idApartmentName: indexOfSM['Month'],
                                      Month: indexOfSM['Month'],
                                    );
                                  });
                            }
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error:${snapshot.error}'),
                            );
                          } else {
                            return Center(
                              child: Text("Hãy thêm dữ liệu".tr()),
                            );
                          }
                        }),
                  )
                ],
              ),
            )),
        MonthOld == 0
            ? Circular()
            : Expanded(
                flex: 5,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Tháng ".tr() + MonthOld.toString(),
                            style: TextStyle(
                                color: Color.fromARGB(255, 149, 208, 238),
                                fontSize: 20,
                                fontFamily: "Urbanist",
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Paid
                      _paid(),
                    ],
                  ),
                )),
      ],
    );
  }

  Widget _paid() {
    return Column(
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
            Text("Dịch vụ: ".tr(),
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist")),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        // trang này chứa code Layout và lấy dữ liệu Aparments từ Firebase.
        User_SBServiceTenant(
          idApartmentBuilding: widget.idApartmentBuilding,
          idServiceAll: widget.idServiceAll,
          idServiceMonth: idServiceMonth,
          idServiceName: widget.idServiceName,
          idApartmentName: widget.idApartmentName,
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
