part of events;

class RouterNavigateEvent extends DispatchEvent {
  final String path;
  RouterNavigateEvent(this.path);
}

class UnknownPathEvent extends DispatchEvent {}
