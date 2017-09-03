part of actions;

class RouterActions extends Actions {
  String get currentPath => window.location.pathname;

  void handle([String path]) {
    dispatch(new RouterNavigateEvent(path ?? currentPath));
  }

  void handleUnknown() {
    dispatch(new UnknownPathEvent());
  }

  void navigate(String path, {String title}) {
    if (currentPath == path) {
      return replace(path, title: title);
    }
    window.history.pushState(null, title ?? document.title, path);
    handle();
  }

  void replace(String path, {String title}) {
    window.history.replaceState(null, title ?? document.title, path);
    handle();
  }
}
