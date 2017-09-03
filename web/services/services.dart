library services;

import 'dart:html';

import '../actions/actions.dart';
import '../stores/stores.dart';

part 'meta_manager.dart';
part 'pop_state_observer.dart';

void run() {
  new MetaManager();
  new PopStateObserver();
}
