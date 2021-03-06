part of events;

class DraftFetchFailedEvent extends DispatchEvent {
  final String id;
  DraftFetchFailedEvent(this.id);
}

class DraftFetchedEvent extends DispatchEvent {
  final String id;
  final String body;
  DraftFetchedEvent(this.id, this.body);
}

class IndexFetchedEvent extends DispatchEvent {
  final int year;
  final Map index;
  IndexFetchedEvent(this.year, this.index);
}

class PostFetchedEvent extends DispatchEvent {
  final int year;
  final int month;
  final String id;
  final String body;
  PostFetchedEvent(this.year, this.month, this.id, this.body);
}

class PostFetchFailedEvent extends DispatchEvent {
  final int year;
  final int month;
  final String id;
  PostFetchFailedEvent(this.year, this.month, this.id);
}
