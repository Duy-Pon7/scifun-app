import 'package:flutter/material.dart';
import 'package:sci_fun/core/services/realtime_service.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _controller = TextEditingController();
  final List<Map<String, dynamic>> _comments = [];

  @override
  void initState() {
    super.initState();

    RealtimeService.I.commentStream.listen((c) {
      setState(() => _comments.insert(0, c));
    });

    RealtimeService.I.notificationStream.listen((n) {
      // demo: log notification
      debugPrint('NOTI: $n');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    try {
      final success =
          await RealtimeService.I.sendNewComment(content: text, parentId: null);
      if (success) {
        _controller.clear();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Không thể gửi bình luận — sẽ thử lại tự động khi kết nối trở lại'),
          ),
        );
      }
    } catch (e, st) {
      // Defensive: prevent any exception from escaping the gesture handler
      print('Unexpected error when sending comment: $e\n$st');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lỗi khi gửi bình luận — thử lại sau'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StreamBuilder<bool>(
          stream: RealtimeService.I.connectionStream,
          initialData: RealtimeService.I.isConnected,
          builder: (context, snap) {
            final connected = snap.data ?? false;
            return Row(
              children: [
                const Text('Comments realtime'),
                const Spacer(),
                Icon(
                  connected ? Icons.cloud_done : Icons.cloud_off,
                  color: connected ? Colors.green : Colors.red,
                  size: 18,
                ),
              ],
            );
          },
        ),
        for (final c in _comments)
          ListTile(
            title: Text('${c['content'] ?? ''}'),
            subtitle: Text('id: ${c['id'] ?? '-'}'),
          ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(hintText: 'Nhập comment...'),
              ),
            ),
            StreamBuilder<bool>(
              stream: RealtimeService.I.connectionStream,
              initialData: RealtimeService.I.isConnected,
              builder: (context, snap) {
                final connected = snap.data ?? false;
                return IconButton(
                  onPressed: connected
                      ? _send
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chưa kết nối STOMP')),
                          ),
                  icon: Icon(
                    Icons.send,
                    color: connected ? null : Colors.grey,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
