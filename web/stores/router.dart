part of stores;

enum RouterLocation {
  home,
  year,
  month,
  post,
  notFound
}

class Router extends Store {
  int _year, _month;
  String _postId;
  RouterLocation _location;

  int get year => _year;
  int get month => _month;
  String get postId => _postId;
  RouterLocation get location => _location;

  Router() : super() {
    handlers.addAll([
      new Handler<RouterNavigateEvent>(_evaluatePath),
      new Handler<UnknownPathEvent>(_handleUnknown)
    ]);
  }

  void _evaluatePath(RouterNavigateEvent event) {
    List<String> segments = event.path.split('/');
    segments.removeWhere((String segment) => segment.isEmpty);

    // Reset router data.
    _location = RouterLocation.notFound;
    _year = null; _month = null; _postId = null;

    if (segments.isEmpty) {
      _location = RouterLocation.home;
      return update();
    }

    try {
      _year = int.parse(segments[0]);
      _location = RouterLocation.year;
    } catch (_) {
      _location = RouterLocation.notFound;
    }

    if (segments.length > 1) {
      try {
        _month = int.parse(segments[1]);
        _location = RouterLocation.month;
      } catch (_) {
        _location = RouterLocation.notFound;
      }
    }

    if (segments.length > 2) {
      _postId = segments[2];
      _location = RouterLocation.post;
    }

    update();
  }

  void _handleUnknown(_) {
    _year = null; _month = null; _postId = null;
    _location = RouterLocation.notFound;
    update();
  }
}
