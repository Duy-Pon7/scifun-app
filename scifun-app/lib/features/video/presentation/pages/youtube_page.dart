import 'package:flutter/material.dart';
import 'package:sci_fun/common/widget/app_youtube_player.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/services/sound_service.dart';

class YoutubePage extends StatefulWidget {
  final String videoUrl;
  final String title;

  const YoutubePage({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<YoutubePage> createState() => _YoutubePageState();
}

class _YoutubePageState extends State<YoutubePage> {
  @override
  void initState() {
    super.initState();
    SoundService.instance.suspendLoop();
  }

  @override
  void dispose() {
    SoundService.instance.restoreLoop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(title: widget.title),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AppYoutubePlayer(
              videoUrl: widget.videoUrl,
              autoPlay: true,
            ),
          ),
        ),
      ),
    );
  }
}
