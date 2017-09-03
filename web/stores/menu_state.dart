part of stores;

class MenuState extends Store {
  bool _open = false;
  bool get isOpen => _open;

  MenuState() : super() {
    handlers.addAll([
      new Handler<MenuVisibilityEvent>(_toggleMenu),
      new Handler<RouterNavigateEvent>(_closeMenu)
    ]);
  }

  void _toggleMenu(MenuVisibilityEvent event) {
    _open = event.open;
    update();
  }

  void _closeMenu(_) {
    _open = false;
    update();
  }
}
