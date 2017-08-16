// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';

@Component(
    selector: 'about-me',
    styleUrls: const ['../css/about_me_component.css'],
    templateUrl: '../html/about_me_component.html')
class AboutMeComponent {
  int get myAge {
    int days = new DateTime.now().difference(new DateTime(1995, 3, 29)).inDays;
    return days ~/ 365;
  }
}
