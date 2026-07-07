import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sci_fun/common/helper/open_link.dart';
import 'package:sci_fun/common/helper/youtube_helper.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

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
  String? _errorMessage;

  bool get _supportsInlinePlayback {
    if (kIsWeb) {
      return false;
    }

    return defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

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
    if (!_supportsInlinePlayback) {
      _videoId = YoutubeHelper.extractVideoId(widget.videoUrl);
      _closeController();
      _setError('Nen tang hien tai chua ho tro phat YouTube trong ung dung.');
      return;
    }

    final nextVideoId = YoutubeHelper.extractVideoId(widget.videoUrl);

    if (nextVideoId == null || nextVideoId.isEmpty) {
      _videoId = null;
      _closeController();
      _setError(
        widget.videoUrl.trim().isEmpty
            ? 'Khong tim thay URL video.'
            : 'Khong the phat video nay.',
      );
      return;
    }

    if (_videoId == nextVideoId && _controller != null) {
      _errorMessage = null;
      if (widget.autoPlay) {
        _controller!.load(nextVideoId);
      } else {
        _controller!.cue(nextVideoId);
      }
      return;
    }

    _videoId = nextVideoId;
    _errorMessage = null;
    _closeController();

    final controller = YoutubePlayerController(
      initialVideoId: nextVideoId,
      flags: YoutubePlayerFlags(
        autoPlay: widget.autoPlay,
        controlsVisibleAtStart: true,
        enableCaption: true,
        useHybridComposition: true,
      ),
    )..addListener(_handleControllerUpdate);

    _controller = controller;

    if (mounted) {
      setState(() {});
    }
  }

  void _handleControllerUpdate() {
    final controller = _controller;
    if (controller == null || !mounted) {
      return;
    }

    final errorCode = controller.value.errorCode;
    if (errorCode == 0) {
      if (_errorMessage != null) {
        setState(() {
          _errorMessage = null;
        });
      }
      return;
    }

    final message = _buildYoutubeErrorMessage(errorCode);
    if (_errorMessage == message) {
      return;
    }

    setState(() {
      _errorMessage = message;
    });
  }

  String _buildYoutubeErrorMessage(int errorCode) {
    switch (errorCode) {
      case 1:
        return 'Lien ket YouTube khong hop le.';
      case 100:
        return 'Video nay khong con kha dung.';
      case 101:
      case 105:
      case 150:
        return 'Video nay khong cho phep phat trong ung dung.';
      case 2:
      case 5:
      default:
        return 'Khong the tai video trong ung dung.';
    }
  }

  void _setError(String message) {
    _errorMessage = message;

    if (mounted) {
      setState(() {});
    }
  }

  void _closeController() {
    final controller = _controller;
    _controller = null;
    if (controller != null) {
      controller.removeListener(_handleControllerUpdate);
      controller.dispose();
    }
  }

  @override
  void dispose() {
    _closeController();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return _VideoPlayerError(
        message: _errorMessage!,
        onOpenExternally: _openExternally,
      );
    }

    if (_videoId == null || _controller == null) {
      return const _VideoPlayerLoading();
    }

    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        key: ValueKey(_videoId),
        controller: _controller!,
        aspectRatio: widget.aspectRatio,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: const ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
        onReady: () {
          if (!mounted) {
            return;
          }

          if (_errorMessage != null) {
            setState(() {
              _errorMessage = null;
            });
          }
        },
      ),
      builder: (context, player) {
        return player;
      },
    );
  }

  Future<void> _openExternally() async {
    final videoId = _videoId;
    if (videoId != null && videoId.isNotEmpty) {
      await openLink(link: 'https://www.youtube.com/watch?v=$videoId');
      return;
    }

    final originalUrl = widget.videoUrl.trim();
    if (originalUrl.isNotEmpty) {
      await openLink(link: originalUrl);
    }
  }
}

class _VideoPlayerLoading extends StatelessWidget {
  const _VideoPlayerLoading();

  @override
  Widget build(BuildContext context) {
    return const AspectRatio(
      aspectRatio: 16 / 9,
      child: ColoredBox(
        color: Colors.black12,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class _VideoPlayerError extends StatelessWidget {
  final String message;
  final Future<void> Function()? onOpenExternally;

  const _VideoPlayerError({
    required this.message,
    this.onOpenExternally,
  });

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            if (onOpenExternally != null) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => onOpenExternally!.call(),
                child: const Text('Mo tren YouTube'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
