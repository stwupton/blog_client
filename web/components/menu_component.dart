// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';

@Injectable()
class PostIndex {
  List<int> years = [2016, 2017];
}

@Component(
    selector: 'menu',
    templateUrl: '../html/menu_component.html',
    providers: const [PostIndex])
class Menu {

  PostIndex postIndex;

  Menu(this.postIndex);

}
