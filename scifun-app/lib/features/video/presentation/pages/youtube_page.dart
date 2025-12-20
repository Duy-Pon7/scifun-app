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
  late YoutubePlayerController _controller;
  bool _hasError = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);

    if (videoId == null || videoId.isEmpty) {
      _hasError = true;
      _errorMessage = 'Không thể phát video: URL không hợp lệ';
      return;
    }

    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
      ),
    );

    /// Lắng nghe sự thay đổi fullscreen
    _controller.addListener(() {
      if (_controller.value.isFullScreen) {
        _enableLandscape();
      } else {
        _enablePortrait();
      }
    });
  }

  @override
  void dispose() {
    _enablePortrait();
    _controller.dispose();
    super.dispose();
  }

  void _enableLandscape() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _enablePortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Scaffold(
        appBar: BasicAppbar(title: widget.title),
        body: Center(
          child: Text(_errorMessage ?? 'Lỗi không xác định'),
        ),
      );
    }

    return Scaffold(
      appBar: BasicAppbar(title: widget.title),
      body: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.blueAccent,
        bottomActions: const [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          FullScreenButton(),
        ],
      ),
    );
  }
}
