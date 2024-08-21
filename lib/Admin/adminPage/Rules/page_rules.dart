import 'package:apartment_management/Admin/adminPage/Rules/add_page_rule.dart';
import 'package:apartment_management/Admin/adminPage/Rules/item_rules.dart';
import 'package:apartment_management/User/components/circular.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RulesPage extends StatefulWidget {
  const RulesPage({super.key});

  @override
  State<RulesPage> createState() => _RulesPageState();
}

class _RulesPageState extends State<RulesPage> {
  String email = FirebaseAuth.instance.currentUser!.email!;
  String? code;
  String? role;
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

          role = userDoc['role'];
        });
      } else {
        print('Người dùng không tồn tại');
      }
    } catch (e) {
      print('Error fetching CODE: $e');
    }
  }

  void itemPageRulesClick(String idDocRule) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Xóa nội quy"),
              content: const Text("Bạn có chắc chắn muốn xóa nội quy này?"),
              actions: [
                // CANCEL BUTTON
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Hủy")),

                // DELETE BUTTON
                TextButton(
                    onPressed: () async {
                      try {
                        // Replace with the correct collection and document paths
                        final tenantRef = FirebaseFirestore.instance
                            .collection('Rules')
                            .doc(code)
                            .collection('Rule')
                            .doc(idDocRule);

                        await tenantRef.delete();
                        print('Xóa nội quy thành công!');
                      } catch (e) {
                        print('Error deleting Apartment: $e');
                      }
                      Navigator.pop(context);
                    },
                    child: const Text("Vâng")),
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nội Quy".tr(),
            style: TextStyle(
                fontSize: 30, fontFamily: "Urbanist", color: Colors.black)),
      ),
      body: code == null
          ? Circular()
          : StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Rules')
                  .doc(code)
                  .collection('Rule')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final indexUM = snapshot.data!.docs[index];
                      // bool isCurrentUser = message['UserEmail'] == email;
                      return ItemPageRules(
                        onTap: () => itemPageRulesClick(indexUM.id),
                        content: indexUM['Content'],
                        fined: indexUM['Fined'],
                        timeStamp: indexUM['TimeStamp'],
                        code: indexUM['CODE'],
                        number: indexUM['Number'],
                        role: role!,
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
      floatingActionButton: role == "1"
          ? FloatingActionButton(
              backgroundColor: Colors.greenAccent,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddRulesPage(cODE: code!)));
              },
              child: Icon(Icons.post_add),
            )
          : null,
    );
  }
}
