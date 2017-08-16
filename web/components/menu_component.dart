// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
// import 'package:angular2/platform/common.dart';

import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

@Component(
    selector: 'menu',
    templateUrl: '../html/menu_component.html',
    styleUrls: const ['../css/menu_component.css'],
    directives: const [ROUTER_DIRECTIVES])
class MenuComponent implements OnInit {

  @Input() int year;
  @Input() int month;
  @Input() String postId;

  Post post;

  // Services
  PostIndex postIndex;
  Router router;

  bool get isOpen => querySelector('menu').classes.contains('open');
  List listValues;

  MenuComponent(this.postIndex, this.router);

  void close() {
    querySelector('menu').classes.remove('open');
  }

  dynamic menuItem(dynamic value) {
    if (value is Post) {
      return (value as Post).title;
    }

    if (value is! int) {
      throw 'Unknown type used for menu item.';
    }

    if (!(value >= 1 && value <= 12)) {
      return value;
    }

    List<String> months = [
      '', 'January', 'Febuary', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];
    
    return months[value].substring(0, 3).toUpperCase();
  }

  void navigate(var value) {
    StringBuffer path = new StringBuffer();
    if (value is Post) {
      path.write('/$year/$month/${value.id}');
    } else if (value is String) {
      path.write(value);
    } else {
      path
        ..write(year == null ? '' : '/$year')
        ..write('/$value');
    }

    router.navigateByUrl(path.toString());
    close();
  }

  Future ngOnInit() async {
    close();

    year = year == null ? null : int.parse('$year');
    month = month == null ? null : int.parse('$month');
    listValues = await postIndex.getIndex(year: year, month: month);
    if (postId != null)
      post = await postIndex.getPost(year, month, postId);
  }

  void open() {
    querySelector('menu').classes.add('open');
  }

}
