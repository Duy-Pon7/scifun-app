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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppYoutubePlayer(
              videoUrl: videoUrl,
              autoPlay: true,
            ),
          ),
        ),
      ),
    );
  }
}
