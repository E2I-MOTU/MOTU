import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';

Widget buildCategoryCard(BuildContext context, String title, String catchphrase, Color color, Widget? nextScreen, bool isCompleted) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                    child: Text(
                      catchphrase,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double.infinity,
                height: 30,
                child: ElevatedButton(
                  onPressed: () {
                    if (nextScreen != null) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => nextScreen),
                      );
                    }
                  },
                  child: const Text('배워보자'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorTheme.colorSecondary,
                    foregroundColor: ColorTheme.colorWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      if (isCompleted)
        Positioned(
          top: 8,
          right: 8,
          child: Icon(
            Icons.emoji_events,
            color: Colors.amber,
            size: 30,
          ),
        ),
    ],
  );
}
