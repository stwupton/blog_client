import 'dart:html';

import 'package:blog_client/post.dart';

import 'package:angular2/core.dart';

@Component(
    selector: 'disqus',
    templateUrl: '../html/disqus_component.html')
class DisqusComponent implements AfterViewInit {

  static const String _JS_SCRIPT = '''
    /**
    *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
    *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/

    var disqus_config = function() {
      this.page.url = 'https://stwupton.github.io/{{year}}/{{month}}/{{postId}}';  // Replace PAGE_URL with your page's canonical URL variable
      this.page.identifier = '{{postId}}'; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };

    (function() { // DON'T EDIT BELOW THIS LINE
      var d = document, s = d.createElement('script');
      s.src = '//stwupton-github-io.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();''';

  @Input() String postId;
  @Input() int year;
  @Input() int month;

  String get _disqusScript {

    Map <String, dynamic> toReplace = {
      'year': year,
      'month': month,
      'postId': postId
    };

    String scriptText = _JS_SCRIPT;
    for (String key in toReplace.keys)
      scriptText = scriptText.replaceAll('{{$key}}', toReplace[key].toString());

    return scriptText;

  }

  void ngAfterViewInit() {
    DivElement disqusContainer = querySelector('#disqus_wrapper');
    if (disqusContainer != null) {
      DivElement thread = new DivElement()
        ..id = 'disqus_thread';
      ScriptElement script = new ScriptElement()
        ..type = 'text/javascript'
        ..appendText(_disqusScript);
      disqusContainer.nodes.addAll([thread, script]);
    }
  }

}
