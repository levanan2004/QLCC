import 'package:apartment_management/Admin/components/con_month_tenant.dart';
import 'package:apartment_management/Admin/feature_page/add_month_room.dart';
import 'package:apartment_management/Admin/feature_page/add_service_month.dart';
import 'package:apartment_management/Admin/page_components/paid_sm_tenant.dart';
import 'package:apartment_management/Admin/page_components/unpaid_sm_tenant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MonthAparment extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceName;
  const MonthAparment({
    super.key,
    required this.idApartmentBuilding,
    required this.idServiceAll,
    required this.idServiceName,
  });

  @override
  State<MonthAparment> createState() => _MonthAparmentState();
}

class _MonthAparmentState extends State<MonthAparment> {
  // Xử lý việc trả về idServiceMonth mỗi lần click vào mục tháng
  String idServiceMonth = "";
  int MonthOld = 999;
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
          .orderBy('Month', descending: false)
          .limit(1)
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
                            return ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  //get the list of ApartmentBuilding
                                  final indexOfSM = snapshot.data!.docs[index];
                                  return MyContainerServiceMonth(
                                    onTap: () => _handleClickReturnMonth(
                                        indexOfSM.id, indexOfSM['Month']),
                                    idApartmentName: indexOfSM['Month'],
                                    Month: indexOfSM['Month'],
                                  );
                                });
                          } else if (snapshot.hasError) {
                            return Center(
                              child: Text('Error:${snapshot.error}'),
                            );
                          } else {
                            return Center(
                              child: Text('Hãy thêm dữ liệu'),
                            );
                          }
                        }),
                  )
                ],
              ),
            )),
        Expanded(
            flex: 5,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        MonthOld == 999
                            ? "Hãy thêm Tháng"
                            : "Tháng " + MonthOld.toString(),
                        style: TextStyle(
                            color: Color.fromARGB(255, 149, 208, 238),
                            fontSize: 20,
                            fontFamily: "Urbanist",
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MyAddServiceMonth(
                                  idApartmentBuilding:
                                      widget.idApartmentBuilding,
                                  idServiceAll: widget.idServiceAll,
                                  idServiceName: widget.idServiceName,
                                ),
                              ),
                            );
                          },
                          child: Icon(Icons.add))
                    ],
                  ),
                  // UnPaid
                  _unpaid(),
                  // Paid
                  _paid(),
                ],
              ),
            )),
      ],
    );
  }

  Widget _unpaid() {
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
            Text("Chưa đóng",
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist")),
            SizedBox(
              width: 20,
            ),
            Icon(Icons.keyboard_double_arrow_down),
            SizedBox(
              width: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyAddMonthRoom(
                        idApartmentBuilding: widget.idApartmentBuilding,
                        idServiceAll: widget.idServiceAll,
                        idServiceMonth: idServiceMonth,
                        idServiceName: widget.idServiceName,
                        Month: MonthOld,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.add))
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
        MonthOld == 999
            ? Center(child: Text('Hãy thêm Căn Hộ'))
            : SBServiceTenantUnPaid(
                idApartmentBuilding: widget.idApartmentBuilding,
                idServiceAll: widget.idServiceAll,
                idServiceMonth: idServiceMonth,
                idServiceName: widget.idServiceName,
              ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 25,
        ),
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
            Text("Đã đóng",
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Urbanist")),
            SizedBox(
              width: 20,
            ),
            Icon(Icons.keyboard_double_arrow_down),
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
        MonthOld == 999
            ? Center(child: Text('Hãy thêm Căn Hộ'))
            : SBServiceTenantPaid(
                idApartmentBuilding: widget.idApartmentBuilding,
                idServiceAll: widget.idServiceAll,
                idServiceMonth: idServiceMonth,
                idServiceName: widget.idServiceName,
              ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Divider(
            thickness: 0.5,
            color: Colors.black,
          ),
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
