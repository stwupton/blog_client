// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';

import 'menu_component.dart';

@Component(
    selector: 'app',
    directives: const [Menu],
    templateUrl: '../html/app_component.html')
class AppComponent {}
