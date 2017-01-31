import 'dart:async';

import 'package:angular2/core.dart';
import 'package:angular2/security.dart';

import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

import 'post_snippet_component.dart';
import 'post_component.dart';

@Component(
    selector: 'content',
    templateUrl: '../html/content_component.html',
    styleUrls: const ['../css/content_component.css'],
    directives: const [PostSnippetComponent, PostComponent],
    providers: const [DomSanitizationService])
class ContentComponent implements OnInit {

  @Input() int year;
  @Input() int month;
  @Input() String postId;

  List<Post> postList;
  Post activePost;

  // Services
  PostIndex postIndex;
  DomSanitizationService sanitizer;

  ContentComponent(this.postIndex, this.sanitizer);

  Future<List<Post>> get _postList async {

    List<Post> _pl = [];
    Future fromMonths(int year) async {
      for (int month in await postIndex.months(year))
        _pl.addAll(await postIndex.getIndex(year: year, month: month));
    }

    Future fromYears() async {
      for (int year in await postIndex.years)
        fromMonths(year);
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
    year = year == null ? null : int.parse('$year');
    month = month == null ? null : int.parse('$month');
    activePost = await postIndex.getPost(year, month, postId);
    postList = await _postList;
  }

}
