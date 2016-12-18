// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
// import 'package:angular2/platform/common.dart';

import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

@Component(
    selector: 'menu',
    templateUrl: '../html/menu_component.html',
    styleUrls: const ['../css/menu_component.css'],
    directives: const [ROUTER_DIRECTIVES],
    providers: const [PostIndex])
class MenuComponent implements OnInit {

  @Input() int year;
  @Input() int month;
  @Input() String postId;

  Post post;

  // Services
  PostIndex postIndex;
  Router router;

  List get listValues => postIndex.getIndex(year: year, month: month);

  MenuComponent(this.postIndex, this.router);

  dynamic monthValue(int value) {

    if (!(value >= 1 && value <= 12))
      return value;

    List<String> months =
        ['', 'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'];
    return months[value];

  }

  void navigate(var value) {

    StringBuffer path = new StringBuffer();
    if (value is Post) {
      path.write('/$year/$month/${value.id}');
    } else {
      path
        ..write(year == null ? '' : '/$year')
        ..write('/$value');
    }

    router.navigateByUrl(path.toString());

  }

  void ngOnInit() {
    if (postId != null)
      post = postIndex.getPost(year, month, postId);
  }

}
