import 'package:angular2/core.dart';
import 'package:angular2/router.dart';

import 'package:blog_client/post.dart';

@Component(
    selector: 'post-snippet',
    templateUrl: '../html/post_snippet_component.html',
    styleUrls: const ['../css/post_snippet_component.css'],
    directives: const [ROUTER_DIRECTIVES])
class PostSnippetComponent {

  @Input() Post post;

  // Services
  Router router;

  PostSnippetComponent(this.router);

  void showPost() {
    int year  = post.published.year,
        month = post.published.month;
    String id = post.id;
    router.navigateByUrl('/$year/$month/$id');
  }

}
