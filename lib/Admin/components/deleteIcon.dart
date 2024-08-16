import 'package:flutter/material.dart';

class IconDelete extends StatefulWidget {
  final Function()? ontap;
  const IconDelete({
    super.key,
    required this.ontap,
  });

  @override
  State<IconDelete> createState() => _IconDeleteState();
}

class _IconDeleteState extends State<IconDelete> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.ontap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Colors.red),
            borderRadius: BorderRadius.circular(3)),
        child: Icon(
          Icons.delete,
          color: Colors.red,
        ),
      ),
    );
  }
}
