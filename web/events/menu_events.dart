part of events;

class MenuVisibilityEvent extends DispatchEvent {
  final bool open;
  MenuVisibilityEvent(this.open);
}
