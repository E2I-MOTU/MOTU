import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class CustomMarkdownStyle {
  static MarkdownStyleSheet fromTheme(BuildContext context) {
    final theme = Theme.of(context);
    return MarkdownStyleSheet(
      h1: theme.textTheme.displayLarge!.copyWith(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      h2: theme.textTheme.displayMedium!.copyWith(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      h3: theme.textTheme.displaySmall!.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      p: theme.textTheme.bodyLarge!.copyWith(
        fontSize: 16,
        height: 1.5,
        color: Colors.black87,
      ),
    );
  }
}
