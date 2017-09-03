part of store;

typedef dynamic HandlerCallback<T>(T e);

class Handler<T> {
  final HandlerCallback<T> _callback;
  Handler(this._callback);
  void execute(T event) => _callback(event);
  bool handles(dynamic event) => event.runtimeType == T;
}
