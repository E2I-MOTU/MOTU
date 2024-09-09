import 'package:flutter/material.dart';
import 'package:motu/text_utils.dart';
import '../../../provider/bookmark_provider.dart';
import '../../theme/color_theme.dart';

Widget buildBookmarkTermCard(BuildContext context, String id, String term, String definition, String example, BookmarkProvider provider) {
  final size = MediaQuery.of(context).size;
  final cardWidth = size.width * 0.9;

  return Center(
    child: Container(
      width: cardWidth,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: ColorTheme.colorPrimary60,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        term,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.white),
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      provider.deleteBookmark(id);
                    },
                  ),
                ],
              ),
              Container(
                width: cardWidth,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  preventWordBreak(definition),
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.start,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
