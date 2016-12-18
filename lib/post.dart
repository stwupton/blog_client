class Post {
  final DateTime published, updated;
  final String title, id, content;
  Post(this.title, this.id, this.content, this.published, {this.updated});
}
