import 'package:flutter/material.dart';

Widget MotuNormalButton(
  context, {
  required String text,
  required Color color,
  required Function() onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(100, 40),
      foregroundColor: Colors.white,
      backgroundColor: color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(fontWeight: FontWeight.bold),
    ),
  );
}

Widget MotuCancelButton({
  required BuildContext context,
  required String text,
  required Function() onPressed,
}) {
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(100, 40),
      foregroundColor: Colors.black,
      backgroundColor: Colors.grey[350],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    onPressed: onPressed,
    child: Text(text),
  );
}
