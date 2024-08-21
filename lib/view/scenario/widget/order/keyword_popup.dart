import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class KeywordPopupWidget extends StatelessWidget {
  String title;
  String content;

  KeywordPopupWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned(
          right: -14,
          top: -4,
          child: IconButton(
            icon: const Icon(
              CupertinoIcons.xmark,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          width: screenSize.width * 0.6,
          height: screenSize.height * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              Text(content),
            ],
          ),
        ),
      ],
    );
  }
}
