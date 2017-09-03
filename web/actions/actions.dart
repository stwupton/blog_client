library actions;

import 'dart:convert';
import 'dart:html';

import 'package:blog_client/actions.dart';

import '../events/events.dart';

part 'index_actions.dart';
part 'menu_actions.dart';
part 'router_actions.dart';

final RouterActions routerActions = new RouterActions();
final IndexActions indexActions = new IndexActions();
