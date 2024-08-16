import 'package:apartment_management/Admin/adminPage/floor_service/child_fs.dart';
import 'package:apartment_management/Admin/adminPage/floor_service/containerAnh.dart';
import 'package:apartment_management/Admin/adminPage/floor_service/handleToSearchDetailsPage.dart';
import 'package:apartment_management/Admin/feature_page/add_floor.dart';
import 'package:apartment_management/Admin/feature_page/add_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyFloorService extends StatefulWidget {
  final String idApartmentBuilding;
  const MyFloorService({
    super.key,
    required this.idApartmentBuilding,
  });

  @override
  State<MyFloorService> createState() => _MyFloorServiceState();
}

class _MyFloorServiceState extends State<MyFloorService> {
  bool _isSearching = false;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _nextToAddFS() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Hãy chọn 1 trong 2 lựa chọn"),
        actions: [
          // Icon chuyển sang trang MyAddFloor
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAddFloor(
                  idApartmentBuilding: widget.idApartmentBuilding,
                ),
              ),
            ),
            child: Icon(
              Icons.elevator_outlined,
              color: Color.fromARGB(255, 163, 214, 184),
              size: 35,
            ),
          ),
          // Icon chuyển sang trang MyAddService
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyAddService(
                  idApartmentBuilding: widget.idApartmentBuilding,
                ),
              ),
            ),
            child: Icon(
              Icons.shop_2,
              color: Color.fromARGB(255, 149, 208, 238),
              size: 35,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _searchApartments(String apartmentNameToSearch) async {
    setState(() {
      _searchResults.clear();
    });
    if (apartmentNameToSearch.isEmpty) return;

    int apartmentName;
    try {
      apartmentName = int.parse(apartmentNameToSearch);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid number')),
      );
      return;
    }

    // Lấy tất cả các Floor trong tòa nhà
    QuerySnapshot<Map<String, dynamic>> floorsSnapshot = await FirebaseFirestore
        .instance
        .collection('ApartmentBuilding')
        .doc(widget.idApartmentBuilding)
        .collection('Floor')
        .get();

    // Lặp qua từng Floor để tìm kiếm Apartment
    for (QueryDocumentSnapshot<Map<String, dynamic>> floor
        in floorsSnapshot.docs) {
      QuerySnapshot<Map<String, dynamic>> apartmentsSnapshot = await floor
          .reference
          .collection('Apartment')
          .where('ApartmentName', isEqualTo: apartmentName)
          .get();

      if (apartmentsSnapshot.docs.isNotEmpty) {
        setState(() {
          _searchResults.addAll(apartmentsSnapshot.docs.map((doc) => {
                'ApartmentBuilding': widget.idApartmentBuilding,
                'Floor': floor.id,
                'ApartmentName': doc['ApartmentName']
              }));
        });
      }
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                // Ảnh
                ContainerAnh(onSearchTap: () {
                  setState(() {
                    _isSearching = true;
                  });
                }),
                // Apartment và ServiceAll (lúc bình thường ko click vào thanh tìm kiếm)
                ChildFloorService(
                    idApartmentBuilding: widget.idApartmentBuilding),
              ],
            ),
          ),
          // Nếu _isSearching == true thì sang trang tìm kiếm. (Khi người dùng click vào thanh tìm kiếm)
          if (_isSearching)
            Positioned.fill(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
                color: Colors.black87,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tìm Kiếm Căn Hộ',
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
                                hintText:
                                    'Nhập số phòng bạn muốn tìm (vd: 1,2,...)',
                              ),
                              keyboardType: TextInputType.number,
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
                              child: Text('Không tìm thấy căn hộ này',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontFamily: "Urbanist")))
                          : ListView.builder(
                              itemCount: _searchResults.length,
                              itemBuilder: (context, index) {
                                final apartment = _searchResults[index];
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8.0),
                                  child: MyButtonSearchToApartmentDetails(
                                      idApartmentBuilding:
                                          apartment['ApartmentBuilding'],
                                      idFloor: apartment['Floor'],
                                      ApartmentName: apartment['ApartmentName'],
                                      apartment: apartment),
                                );
                              },
                            ),
                    ),
                    SizedBox(height: 16.0),
                  ],
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextToAddFS,
        backgroundColor: _isSearching == true
            ? Color.fromARGB(255, 149, 208, 238)
            : Colors.green,
        child: Icon(
          Icons.add,
          color: _isSearching == true ? Colors.black : Colors.white,
          size: 35,
        ),
      ),
    );
  }
}
