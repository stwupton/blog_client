part of actions;

class IndexActions extends Actions {
  static const RESOURCE_URL = 'https://raw.githubusercontent.com/stwupton/blog_posts/master/';

  void fetchIndexes() {
    for (int year = new DateTime.now().year; year >= 2018; year--) {
      HttpRequest.request('${RESOURCE_URL}index/$year.json')
          .then((HttpRequest response) {
            Map index = JSON.decode(response.responseText);
            dispatch(new IndexFetchedEvent(year, index));
          }).catchError((_) => print('Failed to fetch index for year: $year.'));
    }
  }

  void fetchPost(int year, int month, String postId) {
    HttpRequest.request('${RESOURCE_URL}posts/$year/$month/$postId.md')
        .then((HttpRequest response) {
          String postBody = response.responseText;
          dispatch(new PostFetchedEvent(year, month, postId, postBody));
        }).catchError((_) {
          dispatch(new PostFetchFailedEvent(year, month, postId));
        });
  }

  void fetchDraft(String postId) {
    HttpRequest.request('${RESOURCE_URL}drafts/$postId.md')
        .then((HttpRequest response) {
          String postBody = response.responseText;
          dispatch(new DraftFetchedEvent(postId, postBody));
        }).catchError((_) {
          dispatch(new DraftFetchFailedEvent(postId));
        });
  }
}
