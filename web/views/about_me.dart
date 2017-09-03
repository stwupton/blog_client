part of views;

class AboutMe extends ViewComponent {
  Node render() {
    int myAge() {
      int days = new DateTime.now().difference(new DateTime(1995, 3, 29)).inDays;
      return days ~/ 365;
    }

    String htmlText = '''Hello, World! &#x1F642; My name is Steven Upton, I\'m
    ${myAge()} years old and I live in the UK. I\'m a self-taught programmer who
    loves playing and creating video games. I aspire to one day become a
    proffesional game designer and this blog is me logging my journey towards
    that goal. So, I welcome you to embark on this adventure with me and
    please... don\'t be shy. If you enjoy my content (or don\'t!), leave a
    comment or get in touch through one of my social networks on my
    <a href="https://indecks.co/card/steven" target="_blank">Indecks card</a>.''';

    return new DivElement()
      ..id = 'about_me'
      ..nodes.add(new ParagraphElement()
        ..setInnerHtml(htmlText, treeSanitizer: NodeTreeSanitizer.trusted));
  }
}
