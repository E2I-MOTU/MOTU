import 'package:flutter/material.dart';

Widget buildSectionCard(
  BuildContext context, {
  required List<Widget> children,
  Color backgroundColor = Colors.white,
}) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.25),
          blurRadius: 4.0,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    ),
  );
}
