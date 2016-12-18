import 'package:angular2/core.dart';

// import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

@Component(
    selector: 'post',
    templateUrl: '../html/post_component.html',
    styleUrls: const ['../css/post_component.css'])
class PostComponent {

  @Input() Post post;

}
