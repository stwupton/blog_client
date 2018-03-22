part of stores;

class PostIndex extends Store {
  Map _indexes = {};
  Map _falseIndexes = {};
  List<Post> _falseDrafts = [];
  List<Post> _drafts = [];

  List<int> get years => _indexes.keys.toList();

  PostIndex() : super() {
    handlers.addAll([
      new Handler<IndexFetchedEvent>(_onIndexFetched),
      new Handler<PostFetchedEvent>(_onPostFetched),
      new Handler<DraftFetchedEvent>(_onDraftFetched),
      new Handler<PostFetchFailedEvent>(_onPostFetchFail),
      new Handler<DraftFetchFailedEvent>(_onDraftFetchFail)
    ]);
  }

  dynamic _fetchEntries(Map map, List entries) {
    var value;
    for (var entry in entries) {
      if (map[entry] is Map) {
        value = map = map[entry];
      } else {
        return map[entry];
      }
    }
    return value;
  }

  void _fillEntries(Map map, List entries) {
    Map current = map;
    for (var entry in entries) {
      current = current.putIfAbsent(entry, () => {});
    }
  }

  List<int> months(int year) {
    return _indexes[year]?.keys?.toList() ?? [];
  }

  void _onIndexFetched(IndexFetchedEvent event) {
    if (_indexes[event.year] != null) {
      return;
    }
    for (String key in event.index.keys) {
      int month = int.parse(key);
      for (Map postData in event.index[key]) {
        _fillEntries(_indexes, [event.year, month]);
        _indexes[event.year][month][postData['id']] = new Post.fromMap(postData);
      }
    }
    update();
  }

  void _onPostFetched(PostFetchedEvent event) {
    _fillEntries(_indexes, [event.year, event.month]);
    Post post = _indexes[event.year][event.month][event.id];
    if (post == null) {
      return;
    }
    _indexes[event.year][event.month][event.id] = post.withContent(event.body);
    update();
  }

  void _onDraftFetched(DraftFetchedEvent event) {
    _drafts.add(new Post(
        'Previewing Draft: ${event.id}', 
        event.id, event.body, new DateTime.utc(3000), ''));
    update();
  }

  void _onPostFetchFail(PostFetchFailedEvent event) {
    _fillEntries(_falseIndexes, [event.year, event.month]);
    _falseIndexes[event.year][event.month][event.id] =
        new Post.nonExistent(event.id);
    update();
  }

  void _onDraftFetchFail(DraftFetchFailedEvent event) {
    _falseDrafts.add(new Post.nonExistent(event.id));
    update();
  }

  List<Post> posts([int year, int month]) {
    List<Post> posts = [];
    void fromMonths(int year) {
      for (int month in months(year)) {
        posts.addAll(_indexes[year][month].values.toList());
      }
    }

    void fromYears() {
      for (int year in years) {
        fromMonths(year);
      }
    }

    if (month == null) {
      if (year == null) {
        fromYears();
      } else {
        fromMonths(year);
      }
    } else {
      posts.addAll(
          _fetchEntries(_indexes, [year, month])?.values?.toList() ?? []);
    }

    return posts;
  }

  Post post(int year, int month, String id) {
    if (_fetchEntries(_falseIndexes, [year, month, id]) != null) {
      return _falseIndexes[year][month][id];
    }
    return _fetchEntries(_indexes, [year, month, id]);
  }

  Post draft(String id) {
    List<Post> matchingFalseDrafts = _falseDrafts.where((Post post) => post.id == id).toList();
    List<Post> matchingDrafts = _drafts.where((Post post) => post.id == id).toList();
    if (matchingFalseDrafts.length != 0) {
      return matchingFalseDrafts[0];
    } else if (matchingDrafts.length != 0) {
      return matchingDrafts[0];
    }
    return null;
  }
}

class Post {
  final bool exists;
  final DateTime published, updated;
  final String title, id, content, snippet;

  Post(
      this.title,
      this.id,
      this.content,
      this.published,
      this.snippet,
      {this.updated}) : exists = true;

  Post.nonExistent(this.id)
      : title = null,
        content = null,
        published = null,
        snippet = null,
        updated = null,
        exists = false;

  factory Post.fromMap(Map postData) {
    postData['published'] = DateTime.parse(postData['published']);
    if (postData['updated'] != null) {
      postData['updated'] = DateTime.parse(postData['updated']);
    }

    return new Post(
        postData['title'],
        postData['id'],
        postData['content'],
        postData['published'],
        postData['snippet'],
        updated: postData['updated']);
  }

  Post withContent(String content) {
    return new Post(title, id, content, published, snippet, updated: updated);
  }
}
