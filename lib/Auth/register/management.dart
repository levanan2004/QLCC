import 'package:apartment_management/Auth/register/admin_page.dart';
import 'package:apartment_management/Auth/register/user_page.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class ManagementRegister extends StatefulWidget {
  final Function()? onTap;
  const ManagementRegister({super.key, this.onTap});

  @override
  State<ManagementRegister> createState() => _ManagementRegisterState();
}

class _ManagementRegisterState extends State<ManagementRegister> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            leading: GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  margin: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: const Color.fromARGB(255, 52, 52, 52)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  height: 20,
                  child: Image.asset(
                    'assets/icons/icon_arrow.png',
                  ),
                )),
            title: Text(
              "Xin Chào! Đăng ký để Bắt đầu".tr(),
              style: TextStyle(
                fontFamily: 'Urbanist',
                color: Color(0xFF1E232C),
                fontWeight: FontWeight.bold,
              ),
            ),
            bottom: TabBar(
              indicatorPadding: EdgeInsets.all(0), // Xóa padding chỉ báo
              labelPadding: EdgeInsets.all(0), // Xóa padding nhãn
              labelColor: Colors.blue, // Màu văn bản cho tab được chọn
              unselectedLabelColor: Colors.grey, //
              tabs: [
                Tab(
                  icon: Icon(
                    Icons.person,
                  ),
                  text: "Người thuê".tr(),
                ),
                Tab(icon: Icon(Icons.people), text: "Người quản lý".tr()),
              ],
            ),
          ),
          body: TabBarView(
            children: [UserRegisterPage(), AdminRegisterPage()],
          ),
        ),
      ),
    );
  }
}
