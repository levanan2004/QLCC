import 'package:apartment_management/Admin/adminPage/user_management/item_user_management.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String? code;
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];
  @override
  void initState() {
    super.initState();
    fetchCODE();
  }

  // Tìm 'CODE'
  void fetchCODE() async {
    try {
      // Truy xuất document của người dùng hiện tại từ collection 'Users'
      DocumentSnapshot userDoc =
          await FirebaseFirestore.instance.collection('Users').doc(email).get();

      if (userDoc.exists) {
        // Lấy field 'CODE' từ document
        setState(() {
          code = userDoc['CODE'];
        });
      } else {
        print('Người dùng không tồn tại');
      }
    } catch (e) {
      print('Error fetching CODE: $e');
    }
  }

  Future<void> _searchApartments(String emailNeedToSearch) async {
    setState(() {
      _searchResults.clear(); // Xóa kết quả tìm kiếm trước đó
    });

    if (emailNeedToSearch.isEmpty) return;

    try {
      // Tìm kiếm người dùng với email tương ứng
      var userDoc = await FirebaseFirestore.instance
          .collection('Users')
          .doc(emailNeedToSearch)
          .get();

      if (userDoc.exists) {
        setState(() {
          // Thêm thông tin người dùng vào _searchResults
          _searchResults.add({
            'role': userDoc['role'],
            'email': userDoc['email'],
            'CCCD': userDoc['CCCD'],
            'address': userDoc['Address'],
            'name': userDoc['username'],
            'phone': userDoc['Phone'],
            'sex': userDoc['Sex'],
            'CODE': userDoc['CODE'],
          });
        });
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _stopSearching() {
    FocusScope.of(context).unfocus();
    setState(() {
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Quản lý người dùng").tr(),
      ),
      body: _isSearching == true
          ? Positioned.fill(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Tìm Kiếm người thuê".tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Urbanist",
                        )),
                    SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(255, 149, 208, 238),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Button quay về
                          GestureDetector(
                              onTap: _stopSearching,
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 10),
                                height: 40,
                                child: Image.asset(
                                  'assets/icons/icon_arrow.png',
                                ),
                              )),
                          // Thanh nhập địa chỉ tìm kiếm
                          Container(
                            width: 280,
                            padding: EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(30),
                                  topRight: Radius.circular(30)),
                            ),
                            child: TextField(
                              controller: _searchController,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Vui lòng nhập đầy đủ Email...".tr(),
                              ),
                              keyboardType: TextInputType.emailAddress,
                              onChanged: (value) {
                                _searchResults.clear();
                                _searchApartments(value);
                              },
                            ),
                          ),
                          // Thanh Tìm kiếm
                          Container(
                            height: 45,
                            width: 45,
                            child: IconButton(
                                onPressed: () {
                                  _searchApartments(_searchController.text);
                                  print('hehehe');
                                },
                                icon: Icon(
                                  Icons.search,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Expanded(
                      child: _searchResults.isEmpty
                          ? Center(
                              child: Text("Không tìm thấy người này".tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "Urbanist")))
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final user = _searchResults[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: ItemUserManagement(
                                    role: user['role'] ?? "2",
                                    email: user['email'],
                                    CCCD: user['CCCD'] ?? "...",
                                    address: user['address'] ?? "...",
                                    name: user['name'] ?? "...",
                                    phone: user['phone'] ?? "...",
                                    sex: user['sex'] ?? "1",
                                    CODE: user['CODE'],
                                  ),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 3),
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.black87),
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            prefixIcon: Icon(
                              Icons.search,
                              color: Colors.white,
                            ),
                            hintStyle:
                                TextStyle(color: Colors.grey, fontSize: 13),
                            hintText:
                                "Nhập emai của người bạn muốn kiếm..".tr()),
                        onTap: () {
                          setState(() {
                            _isSearching = true;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 8,
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('Users')
                        .where('CODE', isEqualTo: code)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        // Lọc các document dựa trên field 'role'
                        var filteredUsers = snapshot.data!.docs.where((doc) {
                          // Lọc bỏ các document có field 'role' bằng 1
                          return !doc.data().containsKey('role') ||
                              doc['role'] != "1";
                        }).toList();

                        if (filteredUsers.isEmpty) {
                          return Center(
                              child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  icon: Icon(
                                    Icons.arrow_back_ios,
                                    color: Colors.blue,
                                  )),
                              Text("Không tìm thấy thông tin tài khoản".tr()),
                            ],
                          ));
                        }
                        return ListView.builder(
                          itemCount: filteredUsers.length,
                          itemBuilder: (context, index) {
                            final indexUM = filteredUsers[index];
                            // bool isCurrentUser = message['UserEmail'] == email;
                            return ItemUserManagement(
                              role: indexUM['role'],
                              email: indexUM['email'],
                              CCCD: indexUM['CCCD'],
                              address: indexUM['Address'],
                              name: indexUM['username'],
                              phone: indexUM['Phone'],
                              sex: indexUM['Sex'],
                              CODE: indexUM['CODE'],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Lỗi: ${snapshot.error}'),
                        );
                      }
                      return const Center(
                        child: Circular(),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
