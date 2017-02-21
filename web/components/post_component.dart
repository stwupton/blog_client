import 'dart:html';
import 'dart:js';

import 'package:angular2/core.dart';
import 'package:angular2/security.dart';

// import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';

@Component(
    selector: 'post',
    templateUrl: '../html/post_component.html',
    styleUrls: const ['../css/post_component.css'],
    directives: const [SafeInnerHtmlDirective])
class PostComponent implements OnInit {

  @Input() Post post;

  DivElement postBody;

  // Services
  DomSanitizationService sanitizer;

  PostComponent(this.sanitizer);

  void adaptElements() {

    void adapt(IFrameElement iFrame, num width, num heightPercentage) {

      num difference;
      if (postBody.contentEdge.width < width) {
        difference = width - postBody.contentEdge.width;
        width -= difference;
      }

      num height = width / 100 * heightPercentage;
      iFrame
        ..width = '$width'
        ..height = '$height';

    }

    ElementList<IFrameElement> iFrames = postBody.querySelectorAll('iframe');
    ElementList<ImageElement>  images  = postBody.querySelectorAll('img');

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

  void ngOnInit() {

    postBody = querySelector('post div#body');
    postBody.setInnerHtml(post.content, treeSanitizer: NodeTreeSanitizer.trusted);
    adaptElements();

    context['hljs'].callMethod('initHighlighting');
    context['hljs']['initHighlighting']['called'] = false;

  }

}
