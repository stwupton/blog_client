part of actions;

class MenuActions extends Actions {
  void close() {
    dispatch(new MenuVisibilityEvent(false));
  }

  void open() {
    dispatch(new MenuVisibilityEvent(true));
  }
}
