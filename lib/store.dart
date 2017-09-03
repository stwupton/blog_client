library store;

import 'dart:async';

import 'dispatch/dispatch.dart';

export 'dispatch/dispatch.dart';

part 'handler.dart';

class Store implements DispatchReceiver {
  final List<Handler<DispatchEvent>> handlers = [];
  final StreamController<Null> _updateController =
      new StreamController<Null>.broadcast();

  Stream<Null> get onUpdate => _updateController.stream;

  void handle(DispatchEvent event) {
    handlers
        .where((Handler handler) => handler.handles(event))
        .forEach((Handler handler) => handler.execute(event));
  }

  void update() {
    _updateController.add(null);
  }
}
