import 'package:apartment_management/Admin/components/con_apartment_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SBApartmentDetails extends StatefulWidget {
  final String idApartmentFloor;
  final String idApartmentBuilding;
  final String idApartment;
  const SBApartmentDetails(
      {super.key,
      required this.idApartmentFloor,
      required this.idApartmentBuilding,
      required this.idApartment});

  @override
  State<SBApartmentDetails> createState() => _SBApartmentDetailsState();
}

class _SBApartmentDetailsState extends State<SBApartmentDetails> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("ApartmentBuilding")
              .doc(widget.idApartmentBuilding)
              .collection("Floor")
              .doc(widget.idApartmentFloor)
              .collection("Apartment")
              .doc(widget.idApartment)
              .collection("Tenant")
              .orderBy("Email", descending: false)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    //get the list of ApartmentBuilding
                    final indexOfAD = snapshot.data!.docs[index];
                    return MyContainerApartmentDetails(
                      onTap: () {},
                      Email: indexOfAD['Email'],
                      Name: indexOfAD['Name'],
                      Sex: indexOfAD['Sex'],
                      idApartmentBuilding: widget.idApartmentBuilding,
                      idApartmentFloor: widget.idApartmentFloor,
                      idApartment: widget.idApartment,
                      tenantId: indexOfAD.id,
                    );
                  });
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error:${snapshot.error}'),
              );
            }
            return Center(
              child: Text("Không Có Dữ Liệu"),
            );
          }),
    );
  }
}
