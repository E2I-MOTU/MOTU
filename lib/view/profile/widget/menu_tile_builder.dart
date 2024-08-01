import 'package:flutter/material.dart';

Widget buildMenuTile({
  required String title,
  required VoidCallback onTap,
}) {
  return ListTile(
    title: Text(title),
    onTap: onTap,
    trailing: Icon(Icons.arrow_forward_ios, color: Colors.grey),
  );
}