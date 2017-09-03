// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of views;

class App extends ViewComponent {
  Node render() {
    return new DivElement()
      ..id = 'app'
      ..nodes.addAll([
        new Menu().html,
        new ContentWindow().html
      ]);
  }
}
