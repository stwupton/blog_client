// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'container_component.dart';

@Component(
    selector: 'app',
    directives: const [ContainerComponent, ROUTER_DIRECTIVES],
    templateUrl: '../html/app_component.html')
@RouteConfig(const [
  const Route(path: '/', name: 'Home', component: ContainerComponent, useAsDefault: true),
  const Route(path: '/:year', name: 'Months', component: ContainerComponent),
  const Route(path: '/:year/:month', name: 'Posts', component: ContainerComponent),
  const Route(path: '/:year/:month/:post_id', name: 'Post', component: ContainerComponent)
])
class AppComponent {}
