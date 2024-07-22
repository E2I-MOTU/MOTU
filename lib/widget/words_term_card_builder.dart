import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

Widget buildTermCard(BuildContext context, String term, String definition, String example) {
  return Center(
    child: AspectRatio(
      aspectRatio: 3 / 2,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        child: FlipCard(
          direction: FlipDirection.HORIZONTAL,
          front: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                term,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          back: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.orangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  definition,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  "예시: $example",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}