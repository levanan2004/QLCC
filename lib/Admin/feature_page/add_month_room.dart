import 'package:apartment_management/User/components/button.dart';
import 'package:apartment_management/User/components/email_textformf.dart';
import 'package:apartment_management/User/components/number_textform.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyAddMonthRoom extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceMonth;
  final int Month;
  final String idServiceName;
  const MyAddMonthRoom({
    super.key,
    required this.idApartmentBuilding,
    required this.idServiceAll,
    required this.idServiceMonth,
    required this.idServiceName,
    required this.Month,
  });

  @override
  State<MyAddMonthRoom> createState() => _MyAddMonthRoomState();
}

class _MyAddMonthRoomState extends State<MyAddMonthRoom> {
  final _formKey = GlobalKey<FormState>(); // Create a global Form key
  // User
  final currentUser = FirebaseAuth.instance.currentUser!;
  // 2 biến chứa 2 giá trị Floor và Apartment
  String varFloor = "";
  String varApartment = "";
  // Text Controller
  final ApartmentNameController = TextEditingController();
  final FloorController = TextEditingController();
  final TenantEmailController = TextEditingController();
  final MoneyController = TextEditingController();
  final UnitController = TextEditingController();

  // Hàm truy xuất vào ApartmentBuilding -> Floor -> Apartment lấy 2 id Floor và Apartment
  Future<void> fetchData() async {
    try {
      // Tạo 2 biến này để kiểm tra các id bên Floor -> Apartment có trùng không để lấy id của nó và thực hiện truy xuất
      String floor = FloorController.text.trim().toString();
      String apartmentName = ApartmentNameController.text.trim().toString();
      // Truy xuất và lấy id của Floor
      QuerySnapshot floorSnapshot = await FirebaseFirestore.instance
          .collection('ApartmentBuilding')
          .doc(widget.idApartmentBuilding)
          .collection('Floor')
          .where('Floor', isEqualTo: int.parse(floor))
          .get();

      if (floorSnapshot.docs.isNotEmpty) {
        QueryDocumentSnapshot floorDoc = floorSnapshot.docs.first;
        varFloor = floorDoc.id;

        // Truy xuất và lấy id của Apartment
        QuerySnapshot apartmentSnapshot = await floorDoc.reference
            .collection('Apartment')
            .where('ApartmentName', isEqualTo: int.parse(apartmentName))
            .get();

        if (apartmentSnapshot.docs.isNotEmpty) {
          QueryDocumentSnapshot apartmentDoc = apartmentSnapshot.docs.first;
          varApartment = apartmentDoc.id;

          // Sử dụng apartmentId để thực hiện các thao tác khác
          print('ID của Apartment là: $varApartment');
        } else {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Center(
                      child: Text(
                        "Không tìm thấy phòng, do chưa có người ở. Bạn vui lòng xóa Phòng vừa tạo"
                            .tr(),
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Urbanist",
                        ),
                      ),
                    ),
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Center(
                    child: Text(
                      "Không tìm thấy Tầng, do chưa có người ở. Bạn vui lòng xóa Phòng vừa tạo"
                          .tr(),
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: "Urbanist",
                      ),
                    ),
                  ),
                ));
      }
    } catch (e) {
      print('Lỗi xảy ra: $e');
    }
  }

  Future<void> QueryTenant() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('ApartmentBuilding')
        .doc(widget.idApartmentBuilding)
        .collection('Floor')
        .doc(varFloor)
        .collection('Apartment')
        .doc(varApartment)
        .collection('Tenant') // Tennat là room ( chứa các member)
        .get();
    // Nếu doc() trong Collection('Tenant') không rỗng
    if (querySnapshot.docs.isNotEmpty) {
      WriteBatch batch = FirebaseFirestore.instance.batch();
      // Chạy qua từng dòng doc() của Collection('Tenant')
      for (QueryDocumentSnapshot tenantDoc in querySnapshot.docs) {
        // tạo biến tenantEmail = Email trong Collection('Tenant')
        String tenantEmail = tenantDoc['Email'];

        // So sánh với email trong Collection('Users')
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('email', isEqualTo: tenantEmail)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          DocumentReference userRef = userSnapshot.docs.first.reference;
          DocumentReference serviceRef =
              userRef.collection('ServiceAll').doc(widget.idServiceAll);
          await FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentSnapshot serviceSnapshot =
                await transaction.get(serviceRef);
            //(Nếu ServiceAll đã tồn tại thì chỉ tạo Month, Nếu chưa thì tạo ServiceAll và Month)
            // Nếu ServiceAll chưa tồn tại, tạo mới
            if (!serviceSnapshot.exists) {
              transaction.set(serviceRef, {
                'ServiceName': widget.idServiceName,
              });
              // Thêm vào tháng
              DocumentReference monthRef =
                  serviceRef.collection('Month').doc(widget.idServiceMonth);
              transaction.set(monthRef, {
                'Month': widget.Month,
              });
              // Thêm tin nhắn của user khi Admin thêm ServiceAll(nó sẽ tự thêm Service và Month) cho các Menmber trong Apartment nào đó được chỉ định
              FirebaseFirestore.instance.collection('Notifications').add({
                'Title': tr('Bạn có 1 dịch vụ mới'),
                'Content': tr(
                  'Hãy vào xem chi tiết dịch vụ mới, bạn đã được Quản lý thêm dịch vụ {idServiceName} trong tháng: {Month}',
                  namedArgs: {
                    'idServiceName': widget.idServiceName,
                    'Month': widget.Month.toString()
                  },
                ),
                'UserEmail': tenantEmail,
                'Status': false,
                'Timestamp': Timestamp.now(),
              });
            } else {
              // Tìm Month document
              DocumentReference monthRef =
                  serviceRef.collection('Month').doc(widget.idServiceMonth);
              DocumentSnapshot monthSnapshot = await transaction.get(monthRef);
              // Nếu ServiceAll đã tồn tại thì xem xét tiếp
              // Nếu Month chưa tồn tại, tạo mới
              if (!monthSnapshot.exists) {
                transaction.set(monthRef, {
                  'idServiceMonth': widget.idServiceMonth,
                });
                // Thêm tin nhắn của user khi ServiceAll đã tồn tại thì thêm mỗi tháng thôi
                FirebaseFirestore.instance.collection('Notifications').add({
                  'Title': 'Bạn có tháng dịch vụ mới',
                  'Content':
                      'Hãy vào xem chi tiết ${widget.idServiceName}, bạn đã được Quản lý thêm dịch vụ ${widget.idServiceName} tháng ${widget.Month}',
                  'UserEmail': tenantEmail,
                  'Status': false,
                  'Timestamp': Timestamp.now(),
                });
              } else {
                // Nếu Month đã tồn tại, hiển thị dialog
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("Thông báo".tr()),
                        content: Text("Tháng này đã tồn tại".tr()),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text("Đóng".tr()),
                          ),
                        ],
                      );
                    });
              }
            }
          });
        } else {
          print('No user found with email: $tenantEmail');
        }
      }

      await batch.commit().then((_) {
        print('Tenant data and potentially user data updated successfully!');
      }).catchError((error) {
        print('Error updating data: $error');
      });
    } else {
      print('No tenants found for this apartment');
    }
  }

  // Button thêm các dữ liệu trong các TextField vào firebase
  void addDataSR() async {
    // <1. buộc người dùng phải nhập vào các TextFieldForm>
    if (_formKey.currentState!.validate()) {
      // <2. Kiểm tra xem các TextFieldForm có rỗng không nếu rỗng sẽ xử lý>
      if (ApartmentNameController.text.isNotEmpty ||
          FloorController.text.isNotEmpty ||
          TenantEmailController.text.isNotEmpty ||
          MoneyController.text.isNotEmpty ||
          UnitController.text.isNotEmpty) {
        // <3. Kiểm tra xem người dùng nhập vào ApartmentController xem đã có trong Data chưa? nếu chưa thì mới thêm>
        final roomCollection = FirebaseFirestore.instance
            .collection('ApartmentBuilding')
            .doc(widget.idApartmentBuilding)
            .collection('ServiceAll')
            .doc(widget.idServiceAll)
            .collection('Month')
            .doc(widget.idServiceMonth)
            .collection('Room');

        // Use a query to check for existing 'ApartmentName'
        final queryRoomSnapshot = await roomCollection
            .where('ApartmentName',
                isEqualTo: int.parse(ApartmentNameController.text.trim()))
            .get();
        // <3.a Kiểm tra xem nếu đã có Apartment này trong Data thì xuất Dialog ra thông báo>
        if (queryRoomSnapshot.docs.isNotEmpty) {
          // ApartmentName already exists, show dialog
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Thông báo").tr(),
                content: Text(
                    "Tháng này bạn đã ghi biên lai dịch vụ cho căn hộ ".tr() +
                        ApartmentNameController.text),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Đóng").tr(),
                  ),
                ],
              );
            },
          );
        }
        // </3.a Kết thúc>
        // <3.b Nếu không có Apartment trong Data thì thêm>
        else {
          // Nếu người dùng nhập vào ApartmentName không trùng với ApartmentName trong Apartment(ApartmentBuilding) nó sẽ thêm
          if (queryRoomSnapshot.docs.isEmpty) {
            // Thêm dữ liệu vào Room
            await FirebaseFirestore.instance
                .collection('ApartmentBuilding')
                .doc(widget.idApartmentBuilding)
                .collection('ServiceAll')
                .doc(widget.idServiceAll)
                .collection('Month')
                .doc(widget.idServiceMonth)
                .collection('Room')
                .add({
              'ApartmentName': int.parse(ApartmentNameController.text.trim()),
              'Floor': int.parse(FloorController.text.trim()),
              'TenantEmail': TenantEmailController.text.trim(),
              'Money': int.parse(MoneyController.text.trim()),
              'Unit': int.parse(UnitController.text.trim()),
              'Status': false,
              'TimeStamp': Timestamp.now(),
            });
            Navigator.pop(context);
          }
          // Sử dụng hàm fetchData và lấy 2 giá trị varFloor, varApartment sau khi xử lý
          await fetchData();
          // Lệnh truy cập vào Tenant
          await QueryTenant();
        }
        // </3.b Kết thúc>
      }
      ;
    }
    // </2. Kết thúc>
    // </1. Kết thúc>
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(255, 52, 52, 52)),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          height: 40,
                          child: Image.asset(
                            'assets/icons/icon_arrow.png',
                          ),
                        )),
                    const SizedBox(
                      height: 25,
                    ),
                    //welcome back message
                    Text(
                      "Thêm dịch vụ ".tr() + widget.idServiceName,
                      style: TextStyle(
                        fontFamily: 'Urbanist',
                        color: Color(0xFF1E232C),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    // Tên Tòa Nhà Chung Cư
                    NumberTextForm(
                        controller: ApartmentNameController,
                        hintText: "Tên Căn Hộ (vd: 1, 2, 50,...)".tr(),
                        icon: Icon(Icons.home_outlined),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Tên Tòa Nhà Chung Cư
                    NumberTextForm(
                        controller: FloorController,
                        hintText: "Tầng Của Căn Hộ (vd: 1, 2,...)".tr(),
                        icon: Icon(Icons.elevator),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    EmailTextForm(
                        controller: TenantEmailController,
                        hintText: "Email người thuê phòng".tr(),
                        icon: Icon(Icons.email),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    // Tên Chủ Nhà
                    NumberTextForm(
                        controller: UnitController,
                        hintText: "Số đơn vị sử dụng (vd: 1500)".tr(),
                        icon: Icon(Icons.numbers),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    NumberTextForm(
                        controller: MoneyController,
                        hintText: "Tổng số tiền phải trả".tr(),
                        icon: Icon(Icons.monetization_on),
                        obscureText: false),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    // Button Login
                    GestureDetector(
                      onTap: addDataSR,
                      child: MyButton(
                        text: "Thêm".tr(),
                        color: Colors.black,
                        colorText: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
