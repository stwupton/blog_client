// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:html';

import 'actions/actions.dart';
import 'dispatch_manager.dart';
import 'services/services.dart' as services;
import 'stores/stores.dart';
import 'views/views.dart';

void main() {
  dispatchManager.registerAllDispatchers([
    routerActions,
    indexActions
  ]);

  dispatchManager.registerAllReceivers([
    postIndex,
    router
  ]);

  services.run();
  indexActions.fetchIndexes();

  document.body.nodes.add(new App().html);

  // Handle window location aftr initial render.
  routerActions.handle();
}
