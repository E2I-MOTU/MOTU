import 'package:flutter/material.dart';
import '../../theme/color_theme.dart';

Widget buildCategoryCard(BuildContext context, String title, String catchphrase, Color color, Widget? nextScreen, bool isCompleted) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
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
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        catchphrase,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
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
                backgroundColor: ColorTheme.colorPrimary,
                foregroundColor: ColorTheme.colorWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
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
