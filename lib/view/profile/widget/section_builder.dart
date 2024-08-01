import 'package:flutter/material.dart';

Widget buildSectionCard(BuildContext context, {required List<Widget> children}) {
  return Card(
    elevation: 4.0,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ...children,
        ],
      ),
    ),
  );
}