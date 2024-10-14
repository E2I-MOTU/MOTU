import 'package:flutter/material.dart';
import 'package:motu/src/design/color_theme.dart';

class LinearIndicator extends StatelessWidget {
  final int current;
  final int total;

  const LinearIndicator({
    super.key,
    required this.current,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Container(
          width: screenWidth,
          height: 12,
          decoration: const BoxDecoration(
            color: ColorTheme.colorTertiary,
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: current / total,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                child: Container(
                  color: ColorTheme.colorPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
