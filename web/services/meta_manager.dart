part of services;

class MetaManager {
  MetaElement title = new MetaElement()
    ..attributes['property'] = 'og:title'
    ..content = '';

  MetaElement type = new MetaElement()
    ..attributes['property'] = 'og:type'
    ..content = 'website';

  MetaElement image = new MetaElement()
    ..attributes['property'] = 'og:image'
    ..content = '';

  MetaElement url = new MetaElement()
    ..attributes['property'] = 'og:url'
    ..content = '';

  MetaElement description = new MetaElement()
    ..attributes['property'] = 'og:description'
    ..content = '';

  MetaManager() {
    router.onUpdate.listen(_update);
    postIndex.onUpdate.listen(_update);

    document.head.nodes.addAll([title, type, image, url, description]);
  }

  void _update(_) {
    _updateTitle();
    _updateMeta();
  }

  void _updateMeta() {
    url.content = window.location.href;
    image.content = 'https://lh3.googleusercontent.com/BLSrE-x7j-XcGei1MlwVeRKxez75Md0Ho2cEtV2FT9QLTt6il4zMlC1t4w-pvfeYNL0PIbSOWEdUbw=s179-rw-no';
    void setDefault() {
      title.content = 'Steven Upton\'s Blog';
      description.content = 'Steven Upton\'s game design adventures.';
    }

    if (router.location == RouterLocation.post) {
      Post post = postIndex.post(router.year, router.month, router.postId);
      if (post == null) {
        setDefault();
      } else {
        title.content = '${post.title} | Steven Upton\'s Blog';
        description.content = post.snippet;
      }
    } else {
      setDefault();
    }
  }

  void _updateTitle() {
    if (router.location == RouterLocation.post) {
      Post post = postIndex.post(router.year, router.month, router.postId);
      if (post == null) {
        document.title = 'Steven Upton\'s Blog';
      } else {
        document.title = '${post.title} | Steven Upton\'s Blog';
      }
    } else {
      document.title = 'Steven Upton\'s Blog';
    }
  }
}
