import 'package:flutter/material.dart';

class Skeleton extends StatelessWidget {
  final double width;
  final double height;

  const Skeleton({required this.width, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
