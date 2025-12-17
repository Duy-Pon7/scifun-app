import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'realtime_service.dart';

class WsBootstrap extends StatefulWidget {
  const WsBootstrap({
    super.key,
    required this.wsUrl,
  });

  final String wsUrl;

  @override
  State<WsBootstrap> createState() => _WsBootstrapState();
}

class _WsBootstrapState extends State<WsBootstrap> with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    // Bạn chỉnh key theo app bạn
    return _storage.read(key: 'access_token');
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    RealtimeService.I.connect(
      wsUrl: widget.wsUrl,
      getToken: _getToken,
      onError: (e) => debugPrint('WS error: $e'),
    );
  }

  @override
  void didUpdateWidget(covariant WsBootstrap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.wsUrl != widget.wsUrl) {
      RealtimeService.I.disconnect();
      RealtimeService.I.connect(
        wsUrl: widget.wsUrl,
        getToken: _getToken,
        onError: (e) => debugPrint('WS error: $e'),
      );
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Tuỳ bạn: resume thì connect lại, pause thì giữ nguyên hoặc disconnect
    if (state == AppLifecycleState.resumed) {
      RealtimeService.I.connect(
        wsUrl: widget.wsUrl,
        getToken: _getToken,
        onError: (e) => debugPrint('WS error: $e'),
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    // Nếu bạn muốn socket sống xuyên app, có thể KHÔNG disconnect ở đây.
    RealtimeService.I.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // widget “ẩn”
  }
}
