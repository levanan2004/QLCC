import 'package:apartment_management/Admin/components/con_service_tenant.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SBServiceTenantUnPaid extends StatefulWidget {
  final String idApartmentBuilding;
  final String idServiceAll;
  final String idServiceMonth;
  final String idServiceName;
  const SBServiceTenantUnPaid(
      {super.key,
      required this.idApartmentBuilding,
      required this.idServiceAll,
      required this.idServiceName,
      required this.idServiceMonth});

  @override
  State<SBServiceTenantUnPaid> createState() => _SBServiceTenantUnPaidState();
}

class _SBServiceTenantUnPaidState extends State<SBServiceTenantUnPaid> {
  @override
  Widget build(BuildContext context) {
    // Hàm xóa Service Tenant(Service Apartment)
    void _deleteServiceTenant(String documentMonthRoom) {
      // show a dialog box asking for confirmation before deleting the post
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Xóa Phòng").tr(),
                content:
                    const Text("Bạn có chắc chắn muốn xóa phòng này?").tr(),
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
                              .collection('ServiceAll')
                              .doc(widget.idServiceAll)
                              .collection('Month')
                              .doc(widget.idServiceMonth)
                              .collection('Room')
                              .doc(documentMonthRoom);
                          await tenantRef.delete();
                          print('Service deleted successfully');
                        } catch (e) {
                          print('Error deleting Service: $e');
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Chắc chắn").tr()),
                ],
              ));
    }

    // Cập nhật trang thái đã đóng tiền chưa
    void _UpdateStatus(String documentMonthRoom, bool newStatus) {
      // show a dialog box asking for confirmation before deleting the post
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: const Text("Cập nhật trạng thái").tr(),
                content: const Text("Bạn có chắc chắn căn hộ này đã dóng tiền?")
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
                              .doc(widget.idApartmentBuilding)
                              .collection('ServiceAll')
                              .doc(widget.idServiceAll)
                              .collection('Month')
                              .doc(widget.idServiceMonth)
                              .collection('Room')
                              .doc(documentMonthRoom);

                          final docSnapshot = await tenantRef.get();
                          // Lấy giá trị hiện tại của trường "Status"
                          final currentStatus =
                              docSnapshot.data()?['Status'] ?? false;

                          // Tính toán giá trị mới cho trường "Status"
                          final newStatus = !currentStatus;
                          await tenantRef.update({'Status': newStatus});
                          // Lấy userEmail trong Room và thêm notification cho userEmail này
                          final currentEmail =
                              docSnapshot.data()!['TenantEmail'];
                          FirebaseFirestore.instance
                              .collection('Notifications')
                              .add({
                            'Title': 'Bạn đã đóng tiền 1 dịch vụ',
                            'Content':
                                'Hãy vào xem chi tiết dịch vụ. Quản lý đã xác thực rằng bạn đã đóng tiền 1 dịch vụ tháng',
                            'UserEmail': currentEmail,
                            'Status': false,
                            'Timestamp': Timestamp.now(),
                          });
                          print('Cập nhật dịch vụ thành công!');
                        } catch (e) {
                          print('Error deleting Service: $e');
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Chắc chắn").tr()),
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
              .doc(widget.idServiceAll)
              .collection('Month')
              .doc(widget.idServiceMonth)
              .collection('Room')
              .where('Status', isEqualTo: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10.0,
                    crossAxisSpacing: 10.0,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the list of ApartmentBuilding
                    final indexOfST = snapshot.data!.docs[index];
                    return MyContainerServiceMonthTenant(
                      onTapDelete: () => _deleteServiceTenant(indexOfST.id),
                      onTapUpdate: () =>
                          _UpdateStatus(indexOfST.id, indexOfST['Status']),
                      idApartmentName: indexOfST['ApartmentName'],
                      Status: indexOfST['Status'],
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error:${snapshot.error}'),
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Circular();
            }
            return Center(
              child: Text("Hãy thêm dữ liệu"),
            );
          }),
    );
  }
}
