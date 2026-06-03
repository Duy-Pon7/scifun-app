import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class AppYoutubePlayer extends StatefulWidget {
  final String videoUrl;
  final bool autoPlay;
  final double aspectRatio;

  const AppYoutubePlayer({
    super.key,
    required this.videoUrl,
    this.autoPlay = false,
    this.aspectRatio = 16 / 9,
  });

  @override
  State<AppYoutubePlayer> createState() => _AppYoutubePlayerState();
}

class _AppYoutubePlayerState extends State<AppYoutubePlayer> {
  YoutubePlayerController? _controller;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _configurePlayer();
  }

  @override
  void didUpdateWidget(covariant AppYoutubePlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoUrl != widget.videoUrl ||
        oldWidget.autoPlay != widget.autoPlay) {
      _configurePlayer();
    }
  }

  void _configurePlayer() {
    final nextVideoId = YoutubePlayerController.convertUrlToId(widget.videoUrl);

    if (nextVideoId == null || nextVideoId.isEmpty) {
      _videoId = null;
      _closeController();
      if (mounted) {
        setState(() {});
      }
      return;
    }

    if (_videoId == nextVideoId && _controller != null) {
      return;
    }

    _videoId = nextVideoId;
    _closeController();
    _controller = YoutubePlayerController.fromVideoId(
      videoId: nextVideoId,
      autoPlay: widget.autoPlay,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        enableCaption: true,
        strictRelatedVideos: true,
        playsInline: true,
      ),
    );

    if (mounted) {
      setState(() {});
    }
  }

  void _closeController() {
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      controller.close();
    }
  }

  @override
  void dispose() {
    _closeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_videoId == null || _controller == null) {
      return _VideoPlayerError(
        message: widget.videoUrl.trim().isEmpty
            ? 'Khong tim thay URL video.'
            : 'Khong the phat video nay.',
      );
    }

    return YoutubePlayerScaffold(
      controller: _controller!,
      aspectRatio: widget.aspectRatio,
      builder: (context, player) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: player,
        );
      },
    );
  }
}

class _VideoPlayerError extends StatelessWidget {
  final String message;

  const _VideoPlayerError({required this.message});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.black12,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
