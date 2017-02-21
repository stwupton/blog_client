class Post {
  final DateTime published, updated;
  final String title, id, content, snippet;

  Post(
      this.title,
      this.id,
      this.content,
      this.published,
      this.snippet,
      {this.updated});

  factory Post.fromMap(Map postData) {
    return new Post(
        postData['title'],
        postData['id'],
        postData['content'],
        postData['published'],
        postData['snippet'],
        updated: postData['updated']);
  }
}
