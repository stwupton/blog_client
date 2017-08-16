import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2/security.dart';

import 'package:blog_client/post.dart';

@Component(
    selector: 'post-snippet',
    templateUrl: '../html/post_snippet_component.html',
    styleUrls: const ['../css/post_snippet_component.css'],
    directives: const [ROUTER_DIRECTIVES, SafeInnerHtmlDirective])
class PostSnippetComponent {

  @Input() Post post;

  // Services
  Router router;
  DomSanitizationService sanitizer;

  bool get isNew =>
    new DateTime.now().difference(post.published) < new Duration(days: 5);

  PostSnippetComponent(this.router, this.sanitizer);

  String formatDate(DateTime date) {
    String daySuffix;
    if (date.day > 10 && date.day < 20) {
      daySuffix = 'th';
    } else {
      switch (date.day % 10) {
        case 1:
          daySuffix = 'st';
          break;
        case 2:
          daySuffix = 'nd';
          break;
        case 3:
          daySuffix = 'rd';
          break;
        default:
          daySuffix = 'th';
      }
    }

    List<String> months = [
      '', 'January', 'Febuary', 'March', 'April', 'May', 'June', 'July',
      'August', 'September', 'October', 'November', 'December'
    ];

    return '${date.day}$daySuffix ${months[date.month]} ${date.year}';
  }

  void showPost() {
    int year  = post.published.year,
        month = post.published.month;
    String id = post.id;
    router.navigateByUrl('/$year/$month/$id');
  }

}
