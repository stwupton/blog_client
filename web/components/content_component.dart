import 'dart:async';
import 'dart:html';

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
    directives: const [PostSnippetComponent, PostComponent, SafeInnerHtmlDirective],
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

  DivElement get disqus => new DivElement()
    ..setInnerHtml(_disqusHtml, treeSanitizer: NodeTreeSanitizer.trusted);

  String get _disqusHtml => '''<div id="disqus_thread"></div>
  <script>
    /**
    *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
    *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/

    var disqus_config = function() {
      this.page.url = 'https://stwupton.github.io/$year/$month/$postId';  // Replace PAGE_URL with your page's canonical URL variable
      this.page.identifier = $postId; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };

    (function() { // DON'T EDIT BELOW THIS LINE
      var d = document, s = d.createElement('script');
      s.src = '//stwupton-github-io.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();
  </script>
  <noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>''';

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
