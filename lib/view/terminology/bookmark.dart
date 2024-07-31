import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widget/bookmark_card_builder.dart';
import '../../provider/bookmark_provider.dart';

class BookmarkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookmarkProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('책갈피'),
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
              return const Center(child: Text('저장된 책갈피가 없습니다.'));
            }

            return ListView.builder(
              itemCount: provider.bookmarks.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: Card(
                    child: ListTile(
                      title: buildBookmarkCard(
                        context,
                        provider.bookmarks[index]['term'] ?? '',
                        provider.bookmarks[index]['definition'] ?? '',
                        provider.bookmarks[index]['example'] ?? '',
                        provider.bookmarks[index]['category'] ?? '',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          provider.deleteBookmark(provider.bookmarks[index]['id']);
                        },
                      ),
                    ),
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
