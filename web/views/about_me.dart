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
    professional game designer and this blog is me logging my journey towards
    that goal. So, I welcome you to embark on this adventure with me and
    please... don\'t be shy. If you enjoy my content (or don\'t!), leave a
    comment or get in touch through one of my social networks below.''';

    // Twitter link.
    AnchorElement twitterLink = new AnchorElement(href: 'https://twitter.com/stwupton')
      ..target = '_blank'
      ..classes.add('social_link')
      ..nodes.add(new ImageElement(src: '/img/twitter.png'));

    // Itch.io link.
    AnchorElement itchLink = new AnchorElement(href: 'https://stwupton.itch.io')
      ..target = '_blank'
      ..classes.add('social_link')
      ..nodes.add(new ImageElement(src: '/img/itchio.png'));

    // Linkedin link.
    AnchorElement linkedinLink = new AnchorElement(href: 'https://www.linkedin.com/in/stwupton/')
      ..target = '_blank'
      ..classes.add('social_link')
      ..nodes.add(new ImageElement(src: '/img/linkedin.png'));

    // Linkedin link.
    AnchorElement twitchLink = new AnchorElement(href: 'https://www.twitch.tv/stwupton')
      ..target = '_blank'
      ..classes.add('social_link')
      ..nodes.add(new ImageElement(src: '/img/twitch.png'));

    return new DivElement()
      ..id = 'about_me'
      ..nodes.addAll([
        new ParagraphElement()
          ..setInnerHtml(htmlText, treeSanitizer: NodeTreeSanitizer.trusted),
        new DivElement()
          ..id = 'social_container'
          ..nodes.addAll([twitterLink, itchLink, linkedinLink, twitchLink])
      ]);
  }
}
