class Post {
  final DateTime published, updated;
  final String title, id, content;

  Post(
      this.title,
      this.id,
      this.content,
      this.published,
      {this.updated});

  factory Post.fromMap(Map postData) {
    return new Post(
        postData['title'],
        postData['id'],
        postData['content'],
        postData['published'],
        updated: postData['updated']);
  }
}
