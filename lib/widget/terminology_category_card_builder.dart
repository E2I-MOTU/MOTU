import 'package:flutter/material.dart';

Widget buildCategoryCard(BuildContext context, String title, String catchphrase, Color color, Widget? nextScreen, bool isCompleted) {
  return Stack(
    children: [
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            Text(
              catchphrase,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
              textAlign: TextAlign.center,
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
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
