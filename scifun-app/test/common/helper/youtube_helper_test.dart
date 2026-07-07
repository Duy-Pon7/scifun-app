import 'package:flutter_test/flutter_test.dart';
import 'package:sci_fun/common/helper/youtube_helper.dart';

void main() {
  group('YoutubeHelper.extractVideoId', () {
    test('extracts video id from embed URL', () {
      const url = 'https://www.youtube.com/embed/UHcQlwgie2Y';

      expect(YoutubeHelper.extractVideoId(url), 'UHcQlwgie2Y');
    });

    test('extracts video id from watch URL', () {
      const url = 'https://www.youtube.com/watch?v=UHcQlwgie2Y';

      expect(YoutubeHelper.extractVideoId(url), 'UHcQlwgie2Y');
    });
  });
}
