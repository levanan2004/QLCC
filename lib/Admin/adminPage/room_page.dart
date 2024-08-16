import 'package:apartment_management/Admin/feature_page/add_apartment.dart';
import 'package:apartment_management/Admin/page_components/pc_apartment.dart';
import 'package:flutter/material.dart';

class MyRoomPage extends StatefulWidget {
  final String idApartmentBuilding;
  final String idFloor;

  final int Floor;

  const MyRoomPage({
    super.key,
    required this.idApartmentBuilding,
    required this.idFloor,
    required this.Floor,
  });

  @override
  State<MyRoomPage> createState() => _MyRoomPageState();
}

class _MyRoomPageState extends State<MyRoomPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ContainerAnh(),
            // Apartment và ServiceAll
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
                    Text("Tầng " + widget.Floor.toString() + ": ",
                        style: TextStyle(
                            color: Colors.black87,
                            fontSize: 25,
                            fontFamily: "Urbanist")),
                    IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text('Cách thêm Phòng'),
                                content: Text(
                                  'Không được thêm như: Tầng 1 phòng 1 hay Tầng 2 phòng 1\n\n'
                                  'Phải thêm Tầng 2 bắt đầu từ số phòng cuối cùng của tầng 1,\n ví dụ: phòng cuối tầng 1 là 15 thì tầng 2 bắt đầu ở phòng 16.',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('Đóng'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        icon: Icon(Icons.help))
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
                SBApartment(
                  idApartmentBuilding: widget.idApartmentBuilding,
                  idApartmentFloor: widget.idFloor,
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
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyAddA(
                idApartmentBuilding: widget.idApartmentBuilding,
                idApartmentFloor: widget.idFloor,
              ),
            ),
          );
        },
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add_home_rounded,
          color: Colors.white,
          size: 35,
        ),
      ),
    );
  }

  Widget _ContainerAnh() {
    return Container(
      height: 300,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/image_lobby.jpg'),
              fit: BoxFit.cover)),
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.bottomRight, colors: [
          Colors.black.withOpacity(.6),
          Colors.black.withOpacity(.1)
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
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
              ],
            ),
            SizedBox(
              height: 70,
            ),
            Text(
              "Bạn muốn tìm căn hộ?",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 30,
            ),
            Container(
                padding: EdgeInsets.symmetric(vertical: 3),
                margin: EdgeInsets.symmetric(horizontal: 40),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white),
                child: TextField(
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                      hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                      hintText: 'Nhập số phòng bạn muốn tìm (vd: 1,2,...)'),
                )),
            SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
    );
  }
}
