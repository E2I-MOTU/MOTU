import 'package:flutter/material.dart';
import 'package:motu/view/terminology/widget/bookmark_terminology_card_builder.dart';
import 'package:provider/provider.dart';
import '../../provider/bookmark_provider.dart';

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookmarkProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('용어 목록'),
        ),
        body: Consumer<BookmarkProvider>(
          builder: (context, provider, child) {
            if (provider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (provider.error != null) {
              return Center(child: Text(provider.error!));
            }
            if (provider.bookmarks.isEmpty) {
              return const Center(child: Text('저장된 용어가 없습니다.'));
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: provider.bookmarks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: buildBookmarkTermCard(
                    context,
                    provider.bookmarks[index]['id'],
                    provider.bookmarks[index]['term'] ?? '',
                    provider.bookmarks[index]['definition'] ?? '',
                    provider.bookmarks[index]['example'] ?? '',
                    provider,
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
