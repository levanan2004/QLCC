import 'package:flutter/material.dart';

class IconUpdate extends StatefulWidget {
  final Function()? ontap;
  final Color? colorContainer;
  const IconUpdate({super.key, required this.ontap, this.colorContainer});

  @override
  State<IconUpdate> createState() => _IconUpdateState();
}

class _IconUpdateState extends State<IconUpdate> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.green),
            borderRadius: BorderRadius.circular(3)),
        child: Icon(
          Icons.done_sharp,
          color: Colors.green,
        ),
      ),
    );
  }
}
