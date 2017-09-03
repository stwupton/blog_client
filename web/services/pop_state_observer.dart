part of services;

class PopStateObserver {
  PopStateObserver() {
    window.onPopState.listen((_) => routerActions.handle());
  }
}
