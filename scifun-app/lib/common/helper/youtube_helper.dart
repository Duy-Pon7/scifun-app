class YoutubeHelper {
  static final RegExp _videoIdPattern = RegExp(r'^[A-Za-z0-9_-]{11}$');

  static String? extractVideoId(String url) {
    final normalizedUrl = url.trim();
    if (normalizedUrl.isEmpty) {
      return null;
    }

    if (_isValidVideoId(normalizedUrl)) {
      return normalizedUrl;
    }

    final uri = Uri.tryParse(normalizedUrl);
    if (uri == null) {
      return null;
    }

    final host = uri.host.toLowerCase();
    final segments =
        uri.pathSegments.where((segment) => segment.isNotEmpty).toList();

    if (host == 'youtu.be') {
      return _validate(segments.isNotEmpty ? segments.first : null);
    }

    if (!_isYoutubeHost(host)) {
      return null;
    }

    final queryVideoId =
        _validate(uri.queryParameters['v'] ?? uri.queryParameters['vi']);
    if (queryVideoId != null) {
      return queryVideoId;
    }

    if (segments.isEmpty) {
      return null;
    }

    if (segments.length >= 2) {
      final route = segments.first.toLowerCase();
      if (route == 'embed' ||
          route == 'shorts' ||
          route == 'live' ||
          route == 'v' ||
          route == 'e') {
        return _validate(segments[1]);
      }
    }

    return _validate(segments.last);
  }

  static String? buildThumbnailUrl(
    String url, {
    bool webp = true,
    bool highQuality = true,
  }) {
    final videoId = extractVideoId(url);
    if (videoId == null) {
      return null;
    }

    final fileName = highQuality ? 'hqdefault' : 'default';
    if (webp) {
      return 'https://i.ytimg.com/vi_webp/$videoId/$fileName.webp';
    }

    return 'https://img.youtube.com/vi/$videoId/$fileName.jpg';
  }

  static bool _isYoutubeHost(String host) {
    return host == 'youtube.com' ||
        host.endsWith('.youtube.com') ||
        host == 'youtube-nocookie.com' ||
        host.endsWith('.youtube-nocookie.com');
  }

  static bool _isValidVideoId(String? value) {
    return value != null && _videoIdPattern.hasMatch(value);
  }

  static String? _validate(String? value) {
    if (_isValidVideoId(value)) {
      return value;
    }
    return null;
  }
}
