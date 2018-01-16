part of views;

class PostSnippet extends ViewComponent {
  final Post post;

  PostSnippet(this.post);

  String _formatDate(DateTime date) {
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

  Node render() {
    Element newTag = new Element.tag('i')
      ..classes.addAll(['material-icons', 'new_tag'])
      ..text = 'fiber_new'
      ..style.visibility =
          new DateTime.now().difference(post.published) < new Duration(days: 5)
              ? 'visible'
              : 'hidden';

    HeadingElement title = new HeadingElement.h2()..text = post.title;
    subscribe(title, 'click',
        (_) => routerActions.navigate(
            '/${post.published.year}/${post.published.month}/${post.id}'));

    String publishDate = _formatDate(post.published);
    String updatedDate = post.updated != null ? _formatDate(post.updated) : null;

    ParagraphElement published = new ParagraphElement()
      ..classes.add('date')
      ..text = 'Published: ${publishDate}';

    ParagraphElement updated = new ParagraphElement()
      ..classes.add('date')
      ..text = 'Updated: ${updatedDate ?? ''}'
      ..style.display =
          updatedDate == null || updatedDate == publishDate ? 'none' : 'block';

    AnchorElement readMoreLink = new AnchorElement()
      ..innerHtml = 'Read more >'
      ..classes.add('read_more');
    subscribe(readMoreLink, 'click', (MouseEvent e) {
      e.preventDefault();
      routerActions.navigate(
          '/${post.published.year}/${post.published.month}/${post.id}');
    });

    ParagraphElement snippet = new ParagraphElement()
      ..classes.add('snippet')
      ..setInnerHtml('${post.snippet} ', treeSanitizer: NodeTreeSanitizer.trusted)
      ..nodes.add(readMoreLink);

    DivElement container = new DivElement()
      ..classes.add('post_snippet')
      ..nodes.addAll([
        newTag,
        title,
        published,
        updated,
        snippet
      ]);

    return container;
  }
}
