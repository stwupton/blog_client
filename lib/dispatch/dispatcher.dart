part of dispatch;

abstract class Dispatcher {
  final StreamController<DispatchEvent> _dispatchController =
      new StreamController<DispatchEvent>.broadcast();
  Stream<DispatchEvent> get onDispatch => _dispatchController.stream;
  void dispatch(DispatchEvent event) {
    _dispatchController.add(event);
  }
}
