part of dispatch;

class DispatchManager {
  final Set<DispatchReceiver> _receivers = new Set<DispatchReceiver>();
  final Map<Dispatcher, StreamSubscription> _dispatchers = {};

  void _dispatch(DispatchEvent event) {
    for (DispatchReceiver receiver in _receivers) {
      receiver.handle(event);
    }
  }

  void registerDispatcher(Dispatcher dispatcher) {
    _dispatchers[dispatcher] ??= dispatcher.onDispatch.listen(_dispatch);
  }

  void registerAllDispatchers(List<Dispatcher> dispatchers) {
    for (Dispatcher dispatcher in dispatchers) {
      _dispatchers[dispatcher] ??= dispatcher.onDispatch.listen(_dispatch);
    }
  }

  void registerReceiver(DispatchReceiver receiver) {
    _receivers.add(receiver);
  }

  void registerAllReceivers(List<DispatchReceiver> receivers) {
    _receivers.addAll(receivers);
  }
}
