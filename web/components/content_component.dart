import 'package:angular2/core.dart';

import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

import 'post_snippet_component.dart';
import 'post_component.dart';

@Component(
    selector: 'content',
    templateUrl: '../html/content_component.html',
    styleUrls: const ['../css/content_component.css'],
    directives: const [PostSnippetComponent, PostComponent],
    providers: const [PostIndex])
class ContentComponent {

  @Input() int year;
  @Input() int month;
  @Input() String postId;

  // Services
  PostIndex postIndex;

  ContentComponent(this.postIndex);

  Post get activePost => postIndex.getPost(year, month, postId);

  List<Post> get postList {

    List<Post> _pl = [];
    void fromMonths(year) {
      for (int month in postIndex.months(year)) {
        _pl.addAll(postIndex.getIndex(year: year, month: month));
      }
    }

    void fromYears() {
      for (int year in postIndex.years) {
        fromMonths(year);
      }
    }

    if (month == null) {
      if (year == null) {
        fromYears();
      } else {
        fromMonths(year);
      }
    } else {
      _pl.addAll(postIndex.getIndex(year: year, month: month));
    }

    return _pl;

  }

}
