import 'dart:async';
import 'dart:html';

import 'store.dart';

export 'dart:html';

class _ElementSubscription {
  Element element;
  StreamSubscription subscription;
  _ElementSubscription(this.element, this.subscription);
}

abstract class ViewComponent {
  static final Set<ViewComponent> _components = new Set<ViewComponent>();
  static bool _lifeCyclesInitialised = false;

  Element _html;
  bool _mounted = false;
  Set<_ElementSubscription> _elementSubscriptions =
      new Set<_ElementSubscription>();
  Set<StreamSubscription> _subscriptions = new Set<StreamSubscription>();

  Element get html {
    if (_html == null) {
      ViewComponent._components.add(this);
      return _html = _ensureElement(render());
    }
    return _html;
  }

  bool get mounted => _mounted;

  ViewComponent() {
    if (!ViewComponent._lifeCyclesInitialised) {
      ViewComponent._lifeCyclesInitialised = true;
      ViewComponent._initLifeCycles();
    }
  }

  static void _initLifeCycles() {
    void _check(List<MutationRecord> _, MutationObserver observer) {
      // Handle newly mounted components.
      ViewComponent._components
          .where((ViewComponent component) =>
              !component._mounted && document.body.contains(component._html))
          .forEach((ViewComponent component) {
            component
              .._mounted = true
              ..onMount();
          });

      // Handle recently unmounted components.
      ViewComponent._components
          .where((ViewComponent component) =>
              component._mounted && !document.body.contains(component._html))
          .toList().forEach((ViewComponent component) {
            component
              .._html = null
              .._mounted = false
              ..onUnmount();
            ViewComponent._components.remove(component);
          });
    }

    new MutationObserver(_check)
        .observe(document.body, childList: true, subtree: true);
  }

  Element _ensureElement(dynamic result) {
    Element element;
    if (result is List) {
      element = new SpanElement()..nodes.addAll(result as List<Element>);
    } else {
      element = result as Element;
    }
    return element..attributes['view-component'] = '';
  }

  void onMount() {}

  void onReRender() {}

  void onUnmount() {
    _subscriptions
        .forEach((StreamSubscription subscription) => subscription.cancel());
    _subscriptions.clear();

    _elementSubscriptions.forEach((_ElementSubscription elementSub) =>
        elementSub.subscription.cancel());
    _elementSubscriptions.clear();
  }

  dynamic render();

  void reRender() {
    if (_html == null) {
      throw 'Cannot re-render an non-rendered component.';
    }
    Element result = _ensureElement(render());
    _refreshAttributes(_html, result);
    _html.nodes = result.nodes;
    onReRender();

    // Remove all element subscriptions which does not have a mounted element.
    _elementSubscriptions
        .where((_ElementSubscription elementSub) =>
            _html != elementSub.element && !_html.contains(elementSub.element))
        .toList().forEach((_ElementSubscription unusedSub) {
          unusedSub.subscription.cancel();
          _elementSubscriptions.remove(unusedSub);
        });
  }

  void _refreshAttributes(Element live, Element fresh) {
    for (String key in fresh.attributes.keys) {
      live.attributes[key] = fresh.attributes[key];
    }
    live.attributes.keys
        .where((String key) => !fresh.attributes.keys.contains(key))
        .toList().forEach(live.attributes.remove);
  }

  void reRenderOnStoreUpdates(List<Store> stores) {
    for (Store store in stores) {
      _subscriptions.add(store.onUpdate.listen((_) => reRender()));
    }
  }

  // Utility function for adding all stream subscriptions to a queue that will
  // be destroyed when the component unmounts the DOM.
  void subscribe(Element element, String event, dynamic callback(dynamic)) {
    _elementSubscriptions.add(
        new _ElementSubscription(element, element.on[event].listen(callback)));
  }

  void subscribeOnce(Element element, String event, dynamic callback(dynamic)) {
    StreamSubscription subscription;
    subscription = element.on[event].listen((Event e) {
      subscription.cancel();
      callback(e);
    });
    _elementSubscriptions.add(new _ElementSubscription(element, subscription));
  }
}
