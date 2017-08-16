import 'dart:async';
import 'dart:html';

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

import 'about_me_component.dart';
import 'disqus_component.dart';
import 'post_snippet_component.dart';
import 'post_component.dart';

@Component(
    selector: 'content',
    templateUrl: '../html/content_component.html',
    styleUrls: const ['../css/content_component.css'],
    directives: const [ROUTER_DIRECTIVES, AboutMeComponent, DisqusComponent, PostSnippetComponent, PostComponent])
class ContentComponent implements OnInit {

  @Input() int year;
  @Input() int month;
  @Input() String postId;

  List<Post> postList;
  List<Post> recentPostList;

  // Services
  PostIndex postIndex;
  Router router;

  ContentComponent(this.postIndex, this.router);

  Future<List<Post>> get _postList async {

    List<Post> _pl = [];
    Future fromMonths(int year) async {
      for (int month in await postIndex.months(year))
        _pl.addAll(await postIndex.getIndex(year: year, month: month));
    }

    Future fromYears() async {
      for (int year in await postIndex.years)
        await fromMonths(year);
    }

    if (month == null) {
      if (year == null)
        await fromYears();
      else
        await fromMonths(year);
    } else {
      _pl.addAll(await postIndex.getIndex(year: year, month: month));
    }

    return _pl;

  }

  Future ngOnInit() async {
    window.scrollTo(0, 0);
    year = year == null ? null : int.parse('$year');
    month = month == null ? null : int.parse('$month');
    postList = await _postList;
    recentPostList = postList.length > 2 ? postList.sublist(0, 3) : postList;
  }

}
