part of views;

class ContentWindow extends ViewComponent {
  List<Element> _generatePostSnippets(List<Post> posts) {
    List<Element> snippets = [];
    for (Post post in posts) {
      snippets.add(new PostSnippet(post).html);
    }
    return snippets;
  }

  void onMount() {
    reRenderOnStoreUpdates([router, postIndex]);
  }

  void onReRender() {
    window.scrollTo(0, 0);
  }

  Node render() {
    final String rssLocation = 'https://raw.githubusercontent.com/stwupton/blog_posts/dev/feed.xml';

    HeadingElement titleHeading = new HeadingElement.h1()
      ..text = 'Steven Upton\'s Blog';
    subscribe(titleHeading, 'click', (_) => routerActions.navigate('/'));

    DivElement content = new DivElement();

    // Re-usable function for adding a "Page not fount" notice to the content.
    void _pageNotFound() {
      content.nodes.addAll([
        new NotFound().html,
        new DivElement()
          ..id = 'recent_posts_header'
          ..nodes.add(new HeadingElement.h2()..text = 'Recent Posts')
      ]);

      List<Post> recentPosts = postIndex.posts()
        ..sort((Post a, Post b) => a.published.isAfter(b.published) ? -1 : 1);
      if (recentPosts.length > 3) {
        recentPosts = recentPosts.sublist(0, 3);
      }

      content.nodes.addAll(_generatePostSnippets(recentPosts));
    }

    if (router.location == RouterLocation.home) {
      content.nodes.addAll([
        new AboutMe().html,
        new DivElement()
          ..id = 'recent_posts_header'
          ..nodes.add(new HeadingElement.h2()..text = 'Recent Posts')
      ]);

      List<Post> recentPosts = postIndex.posts()
        ..sort((Post a, Post b) => a.published.isAfter(b.published) ? -1 : 1);
      if (recentPosts.length > 3) {
        recentPosts = recentPosts.sublist(0, 3);
      }

      content.nodes.addAll(_generatePostSnippets(recentPosts));
    } else if (router.location == RouterLocation.year) {
      List<Post> posts = postIndex.posts(router.year)
        ..sort((Post a, Post b) => a.published.isAfter(b.published) ? -1 : 1);
      if (posts.isEmpty) {
        _pageNotFound();
      } else {
        content.nodes.addAll(_generatePostSnippets(posts));
      }
    } else if (router.location == RouterLocation.month) {
      List<Post> posts = postIndex.posts(router.year, router.month)
        ..sort((Post a, Post b) => a.published.isAfter(b.published) ? -1 : 1);
      if (posts.isEmpty) {
        _pageNotFound();
      } else {
        content.nodes.addAll(_generatePostSnippets(posts));
      }
    } else if (router.location == RouterLocation.post) {
      Post post = postIndex.post(router.year, router.month, router.postId);
      if (post?.content == null && (post?.exists ?? true)) {
        indexActions.fetchPost(router.year, router.month, router.postId);
        content.nodes.add(new DivElement()
          ..id = 'loading_header'
          ..nodes.add(new HeadingElement.h2()..text = 'Loading...'));
      } else if (!post.exists) {
        _pageNotFound();
      } else {
        content.nodes.addAll([
          new PostView(post).html,
          new DisqusChat(router.year, router.month, router.postId).html
        ]);
      }
    } else if (router.location == RouterLocation.notFound) {
      _pageNotFound();
    }

    return new DivElement()
      ..id = 'content_window'
      ..nodes.addAll([
        new DivElement()
          ..id = 'header'
          ..nodes.addAll([
            titleHeading,
            new AnchorElement(href: rssLocation)
              ..title = 'Atom Feed'
              ..target = '_blank'
              ..id = 'rss_button'
              ..nodes.add(new Element.tag('i')
                ..classes.add('material-icons')
                ..text = 'rss_feed'),
          ]),
        content
      ]);
  }
}
