part of views;

class PostView extends ViewComponent {
  Post post;
  DivElement _postBody;

  PostView(this.post) : super();

  void _adaptElements() {
    void adapt(IFrameElement iFrame, num width, num heightPercentage) {
      num difference;
      if (_postBody.contentEdge.width < width) {
        difference = width - _postBody.contentEdge.width;
        width -= difference;
      }

      num height = width / 100 * heightPercentage;
      iFrame
        ..width = '$width'
        ..height = '$height';
    }

    ElementList<IFrameElement> iFrames = _postBody.querySelectorAll('iframe');
    ElementList<ImageElement>  images  = _postBody.querySelectorAll('img');

    for (IFrameElement iFrame in iFrames) {
      num width = num.parse(iFrame.width);
      num heightPercentage = num.parse(iFrame.height) / width * 100;
      adapt(iFrame, width, heightPercentage);
      window.onResize.listen((_) {
        adapt(iFrame, width, heightPercentage);
      });
    }

    void _setImageSize(ImageElement image) {
      num width = image.naturalWidth > 500 ? 500 : image.naturalWidth;
      image.style
        ..maxWidth = '${width}px'
        ..width = '100%';
    }

    for (ImageElement image in images) {
      if (image.complete)
        _setImageSize(image);
      else
        image.onLoad.first.then((_) => _setImageSize(image));
    }
  }

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

  void onMount() {
    _adaptElements();

    context['hljs'].callMethod('initHighlighting');
    context['hljs']['initHighlighting']['called'] = false;
  }

  void onReRender() {
    onMount();
  }

  Node render() {
    DivElement container = new DivElement()
      ..id = 'post'
      ..nodes.addAll([
        new HeadingElement.h1()
          ..id = 'title'
          ..text = post.title,
        new ParagraphElement()
          ..classes.add('date')
          ..text = _formatDate(post.published)
      ]);

    if (post.updated != null) {
      container.nodes.add(new ParagraphElement()
        ..classes.add('date')
        ..text = _formatDate(post.updated));
    }

    _postBody = new DivElement()
      ..id = 'body'
      ..setInnerHtml(md.markdownToHtml(post.content),
          treeSanitizer: NodeTreeSanitizer.trusted);

    return container..nodes.add(_postBody);
  }
}
