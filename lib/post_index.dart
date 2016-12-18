import 'package:angular2/core.dart';

import 'post.dart';

@Injectable()
class PostIndex {

  List<int> years = [2016, 2017];

  List<int> months(int year) {
    return [1, 2, 3, 4];
  }

  List<Post> posts(int year, int month) {
    return [
      new Post(
          'My First Post',
          'my-first-post',
          '<p>Test content</p>',
          new DateTime.now()),
      new Post(
          'My Second Post',
          'my-second-post',
          '<p>test content two</p>',
          new DateTime.now())];
  }

  List getIndex({int year, int month}) {
    if (month != null) return posts(year, month);
    else if (year != null) return months(year);
    else return years;
  }

  Post getPost(int year, int month, String id) {
    return posts(year, month).firstWhere((Post post) => id == post.id);
  }

}
