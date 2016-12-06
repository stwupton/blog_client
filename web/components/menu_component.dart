// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';

@Injectable()
class PostIndex {

  List<int> years = [2016, 2017];

  List<int> months(int year) {
    return [1, 2, 3, 4];
  }

  List<String> titles(int year, int month) {
    return ['My First Post', 'My Second Post'];
  }

}

enum MenuState {
  years,
  months,
  titles
}

@Component(
    selector: 'menu',
    templateUrl: '../html/menu_component.html',
    providers: const [PostIndex])
class Menu {

  PostIndex postIndex;
  List listView;
  MenuState _state;
  List<MenuState> _stateOrder = [MenuState.years, MenuState.months, MenuState.titles];
  int _selectedYear, _selectedMonth;

  Menu(this.postIndex) {
    showYears();
  }

  void navigateForward(var value) {

    int orderIndex = _stateOrder.indexOf(_state) + 1;
    if (orderIndex < _stateOrder.length &&
        _stateOrder[orderIndex] is MenuState) {

      switch (_stateOrder[orderIndex]) {
        case MenuState.months:
          showMonths(value);
          break;
        case MenuState.titles:
          showTitles(value);
          break;
        case MenuState.years:
          break;
      }

    }

  }

  void navigateBackward() {

    int orderIndex = _stateOrder.indexOf(_state) - 1;
    if (orderIndex >= 0 && _stateOrder[orderIndex] is MenuState) {

      switch (_stateOrder[orderIndex]) {
        case MenuState.years:
          showYears();
          break;
        case MenuState.months:
          showMonths(_selectedYear);
          break;
        case MenuState.titles:
          break;
      }

    }

  }

  void showYears() {
    listView = postIndex.years;
    _selectedYear = null;
    _state = MenuState.years;
  }

  void showMonths(int year) {
    listView = postIndex.months(year);
    _selectedYear = year;
    _selectedMonth = null;
    _state = MenuState.months;
  }

  void showTitles(int month) {
    listView = postIndex.titles(_selectedYear, month);
    _selectedMonth = month;
    _state = MenuState.titles;
  }

}
