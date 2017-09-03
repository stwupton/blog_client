part of views;

class NotFound extends ViewComponent {
  Node render() {
    return new DivElement()
      ..id = 'not_found'
      ..nodes.addAll([
        new HeadingElement.h2()
          ..text = 'Not found...',
        new ParagraphElement()
          ..innerHtml = 'Sorry about this &#x1F61F;. If this problem persists then please let me know.'
      ]);
  }
}
