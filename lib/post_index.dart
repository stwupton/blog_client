import 'dart:async';
import 'dart:convert';
import 'dart:html' show HttpRequest;

import 'package:angular2/core.dart';
import 'package:markdown/markdown.dart';

import 'post.dart';

@Injectable()
class PostIndex {

  static const RESOURCE_URL = 'https://raw.githubusercontent.com/stwupton/blog_posts/dev/';

  Map<int, Map> _index = {};
  Map<int, Map<int, List<Post>>> _postCache = {};

  Future<Map<int, Map>> get index async {
    if (_index.isNotEmpty)
      return _index;

    for (int y = new DateTime.now().year; y > 2015; y--) {
      Map index = await _requestIndex(y);
      if (index == null)
        continue;

      // Transform all keys in index to integers.
      List<String> keys = index.keys.toList();
      for (String key in keys) {
        index[int.parse(key)] = index[key];
        index.remove(key);
      }

      _index[y] = index;
    }

    return _index;
  }

  Future<List<int>> get years async =>
    (await index).keys.toList();

  Future<List<int>> months(int year) async =>
    ((await index)[year]?.keys?.toList() ?? []).reversed;

  Future<List<Post>> posts(int year, int month) async {
    Map index = await this.index;
    if (index[year] == null || index[year][month] == null)
      return [];

    if (_postCache[year] != null && _postCache[year][month] != null)
      return _postCache[year][month];

    _postCache[year] ??= {};
    _postCache[year][month] ??= [];

    List<Map> posts = index[year][month];
    for (Map postData in posts) {
      postData['content'] = markdownToHtml(await _requestPostContent(year, month, postData['id']));
      postData['published'] = DateTime.parse(postData['published']);
      postData['updated'] =
          postData['updated'] == null ?
          null :
          DateTime.parse(postData['updated']);

      _postCache[year][month].add(new Post.fromMap(postData));
    }

    _postCache[year][month] = _postCache[year][month].reversed;
    return _postCache[year][month];
  }

  Future<List> getIndex({int year, int month}) async {
    if (month != null && year != null)
      return await posts(year, month);
    else if (year != null)
      return await months(year);
    else
      return await years;
  }

  Future<Post> getPost(int year, int month, String id) async {
    return (await posts(year, month)).firstWhere(
        (Post post) => id == post.id,
        orElse: () => null);
  }

  Future<Map> _requestIndex(int year) async {
    String location = RESOURCE_URL + '/index/$year.json';

    HttpRequest response;
    String responseText;
    try {
      response = await HttpRequest.request(location, method: 'GET');
      responseText = response.responseText;
    } catch (_) {
      return null;
    }

    Map index;
    try {
      index = JSON.decode(responseText);
    } catch (_) {}

    return index;
  }

  Future<String> _requestPostContent(int year, int month, String id) async {
    return await HttpRequest.getString(
        RESOURCE_URL + '/posts/$year/$month/$id.md');
  }

}
