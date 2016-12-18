// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'menu_component.dart';
import 'content_component.dart';

@Component(
    selector: 'container',
    directives: const [MenuComponent, ContentComponent],
    templateUrl: '../html/container_component.html',
    styleUrls: const ['../css/container_component.css'])
class ContainerComponent {

  RouteParams routeParams;

  ContainerComponent(this.routeParams);

}
