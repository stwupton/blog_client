// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'menu_list_component.dart';

@Component(
    selector: 'menu',
    templateUrl: '../html/menu_component.html',
    directives: const [MenuListComponent, ROUTER_DIRECTIVES])
@RouteConfig(const [
  const Route(path: '/', name: 'Home', component: MenuListComponent, useAsDefault: true)
])
class Menu {}
