// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:angular2/router.dart';

import 'package:blog_client/post_index.dart';

import 'components/app_component.dart';

main() {
  bootstrap(AppComponent, [ROUTER_PROVIDERS, PostIndex]);
}
