import 'package:event_bus/event_bus.dart';

EventBus eventBus = EventBus();

class BookmarkEvent {
  final String term;
  final bool isBookmarked;

  BookmarkEvent(this.term, this.isBookmarked);
}
