import 'package:flutter/material.dart';
import 'package:sci_fun/common/widget/app_youtube_player.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';

class YoutubePage extends StatelessWidget {
  final String videoUrl;
  final String title;

  const YoutubePage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: title),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: AppYoutubePlayer(
          videoUrl: videoUrl,
          autoPlay: true,
        ),
      ),
    );
  }
}
