// Copyright (c) 2016, Steven Upton. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
part of views;

class Menu extends ViewComponent {
  final MenuState _state = new MenuState();
  final MenuActions _actions = new MenuActions();

  Menu() : super() {
    dispatchManager.registerReceiver(_state);
    dispatchManager.registerDispatcher(_actions);
  }

  List<LIElement> _getYearListItems() {
    List years = postIndex.years..sort();
    years = years.reversed;

    List<LIElement> items = [];
    for (int year in years) {
      LIElement item = new LIElement()..text = year.toString();
      subscribe(item, 'click', (_) => routerActions.navigate('/$year'));
      items.add(item);
    }

    return items;
  }

  List<LIElement> _getMonthListItems(int year) {
    List monthValues = ['', 'January', 'Febuary', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'];
    List<int> months = postIndex.months(year)..sort();
    months = months.reversed;

    List<LIElement> items = [];
    for (int month in months) {
      LIElement item = new LIElement()..text =
          monthValues[month].substring(0, 3).toUpperCase();
      subscribe(item, 'click', (_) => routerActions.navigate('/$year/$month'));
      items.add(item);
    }

    return items;
  }

  List<LIElement> _getPostListItems(int year, int month) {
    List<Post> posts = postIndex.posts(year, month)
      ..sort((Post a, Post b) => a.published.isAfter(b.published) ? -1 : 1);

    List<LIElement> items = [];
    for (Post post in posts) {
      LIElement item = new LIElement()..text = post.title;
      subscribe(item, 'click', (_) => routerActions.navigate('/$year/$month/${post.id}'));
      items.add(item);
    }

    return items;
  }

  void onMount() {
    reRenderOnStoreUpdates([_state, router, postIndex]);
  }

  Node render() {
    ButtonElement menuButton = new ButtonElement()
      ..id = 'menu_button'
      ..nodes.add(new Element.tag('i')
        ..classes.add('material-icons')
        ..text = 'menu');
    subscribe(menuButton, 'click', (MouseEvent e) {
      e.stopPropagation();
      _state.isOpen ? _actions.close() : _actions.open();
    });

    LIElement homeButton = new LIElement()
      ..id = 'home_button'
      ..nodes.add(new Element.tag('i')
        ..classes.add('material-icons')
        ..innerHtml = '&#xE88A;');
    subscribe(homeButton, 'click', (_) => routerActions.navigate('/'));

    UListElement list = new UListElement()
      ..nodes.add(homeButton);

    List<LIElement> listItems = [];
    if (router.location == RouterLocation.home ||
        router.location == RouterLocation.notFound ||
        router.location == null) {
      listItems = _getYearListItems();
    } else if (router.location == RouterLocation.year) {
      listItems = _getMonthListItems(router.year);
    } else if (router.location == RouterLocation.month ||
        router.location == RouterLocation.post) {
      listItems = _getPostListItems(router.year, router.month);
    }

    // If there are no menu items then add years instead.
    if (listItems.isEmpty) {
      listItems = _getYearListItems();
    }

    list.nodes.addAll(listItems);

    DivElement menu = new DivElement()
      ..id = 'menu'
      ..classes.add(_state.isOpen ? 'open' : 'closed')
      ..nodes.addAll([menuButton, list]);

    // Close menu when a click occurs anywhere else on the page.
    if (_state.isOpen) {
      subscribe(document.body, 'click', (MouseEvent e) {
        if (html != e.target && !html.contains(e.target)) {
          _actions.close();
        }
      });
    }

    return menu;
  }
}
