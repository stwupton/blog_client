import 'dart:async';
import 'dart:html';
import 'dart:js';

import 'package:angular2/core.dart';

// import 'package:blog_client/post_index.dart';
import 'package:blog_client/post.dart';
import 'package:blog_client/post_index.dart';

@Component(
    selector: 'post',
    templateUrl: '../html/post_component.html',
    styleUrls: const ['../css/post_component.css'])
class PostComponent implements OnInit {

  @Input() String postId;
  @Input() int year;
  @Input() int month;

  Post post;
  DivElement postBody;
  PostIndex postIndex;

  PostComponent(this.postIndex);

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

  String formatDate(DateTime date) {
    if (date == null) {
      return '';
    }

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

  Future ngOnInit() async {

    post = await postIndex.getPost(year, month, postId);

    postBody = querySelector('post div#body');
    postBody.setInnerHtml(post.content, treeSanitizer: NodeTreeSanitizer.trusted);
    adaptElements();

    context['hljs'].callMethod('initHighlighting');
    context['hljs']['initHighlighting']['called'] = false;

  }

}
