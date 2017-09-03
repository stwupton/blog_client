part of views;

class DisqusChat extends ViewComponent {
  final int year, month;
  final String postId;

  DisqusChat(this.year, this.month, this.postId) : super();

  String get _disqusScript => '''
    /**
    *  RECOMMENDED CONFIGURATION VARIABLES: EDIT AND UNCOMMENT THE SECTION BELOW TO INSERT DYNAMIC VALUES FROM YOUR PLATFORM OR CMS.
    *  LEARN WHY DEFINING THESE VARIABLES IS IMPORTANT: https://disqus.com/admin/universalcode/#configuration-variables*/

    var disqus_config = function() {
      this.page.url = 'https://stwupton.netlify.com/${year}/${month}/${postId}';  // Replace PAGE_URL with your page's canonical URL variable
      this.page.identifier = '${year}_${month}_${postId}'; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
    };

    (function() { // DON'T EDIT BELOW THIS LINE
      var d = document, s = d.createElement('script');
      s.src = '//stwupton-blog.disqus.com/embed.js';
      s.setAttribute('data-timestamp', +new Date());
      (d.head || d.body).appendChild(s);
    })();''';

  Node render() {
    return new DivElement()
      ..id = 'disqus'
      ..nodes.addAll([
        new DivElement()
          ..id = 'disqus_thread',
        new ScriptElement()
          ..type = 'text/javascript'
          ..appendText(_disqusScript)
      ]);
  }
}
