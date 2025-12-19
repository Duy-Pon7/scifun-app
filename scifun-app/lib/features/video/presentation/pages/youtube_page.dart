import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  YoutubePlayerController? _controller;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId == null || videoId.isEmpty) {
      _hasError = true;
      _errorMessage = 'Không thể phát video: URL không hợp lệ';
      log('Invalid Youtube URL: ${widget.videoUrl}');
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false, // ❌ đừng tin autoplay
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        appBar: BasicAppbar(title: widget.title),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.error_outline,
                    size: 48, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(
                  _errorMessage ?? 'Lỗi không xác định',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Quay lại'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return YoutubePlayerBuilder(
      onEnterFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      },
      onExitFullScreen: () {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      },
      player: YoutubePlayer(
        controller: _controller!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton(),
        ],
        onReady: () {
          // 🔥 AUTOPLAY THẬT
          _controller?.play();
        },
      ),
      builder: (context, player) => Scaffold(
        appBar: BasicAppbar(title: widget.title),
        body: Center(
          child: player,
        ),
      ),
    );
  }
}
