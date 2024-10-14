import 'package:flutter/material.dart';

Widget buildListTile({
  IconData? leadingIcon,
  Widget? leadingWidget,
  required String title,
  String? subtitle,
  Widget? trailing,
  GestureTapCallback? onTap,
}) {
  return ListTile(
    contentPadding: EdgeInsets.zero,
    leading: leadingWidget ?? (leadingIcon != null ? Icon(leadingIcon) : null),
    title: Text(title),
    subtitle: subtitle != null ? Text(subtitle) : null,
    trailing: trailing,
    onTap: onTap,
  );
}