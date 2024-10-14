import 'package:flutter/material.dart';
import 'package:motu/src/features/learning/term/service/bookmark_service.dart';
import 'package:motu/src/common/service/text_utils.dart';
import 'package:provider/provider.dart';
import '../../../../../design/color_theme.dart';

Widget BookmarkTermCardBuilder(BuildContext context, String id, String term,
    String definition, String example) {
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
                      final service =
                          Provider.of<BookmarkService>(context, listen: false);
                      service.deleteBookmark(id);
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
