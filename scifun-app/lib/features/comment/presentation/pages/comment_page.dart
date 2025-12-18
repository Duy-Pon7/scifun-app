import 'package:flutter/material.dart';
import 'package:sci_fun/core/services/realtime_service.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/features/comment/presentation/cubit/comment_pagination_cubit.dart';
import 'package:sci_fun/features/comment/data/model/comment_model.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/core/di/injection.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  final _controller = TextEditingController();
  late final CommentPaginationCubit _commentPaginationCubit;

  @override
  void initState() {
    super.initState();

    _commentPaginationCubit = sl<CommentPaginationCubit>();
    _commentPaginationCubit.loadInitial();

    RealtimeService.I.commentStream.listen((c) {
      try {
        final comment = CommentModel.fromJson(c);
        _commentPaginationCubit.insertNewComment(comment);
      } catch (e) {
        // fallback: ignore malformed realtime payload
        debugPrint('Invalid realtime comment payload: $e');
      }
    });

    RealtimeService.I.notificationStream.listen((n) {
      // demo: log notification
      debugPrint('NOTI: $n');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _commentPaginationCubit.close();
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
        // Header: forum title + connection status
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: Row(
            children: [
              const Text(
                'Diễn đàn',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              const Text(
                'Bình luận',
                style: TextStyle(color: Colors.black54, fontSize: 12),
              ),
              const Spacer(),
              StreamBuilder<bool>(
                stream: RealtimeService.I.connectionStream,
                initialData: RealtimeService.I.isConnected,
                builder: (context, snap) {
                  final connected = snap.data ?? false;
                  return Row(
                    children: [
                      Icon(
                        connected ? Icons.cloud_done : Icons.cloud_off,
                        color: connected ? Colors.green : Colors.red,
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        connected ? 'Realtime' : 'Offline',
                        style: TextStyle(
                          color: connected ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        // Paginated list of comments (forum-style cards)
        SizedBox(
          height: 300,
          child: PaginationListView<CommentEntity>(
            cubit: _commentPaginationCubit,
            itemBuilder: (context, c) => _buildCommentTile(context, c),
            emptyWidget: const Center(child: Text('Chưa có bình luận nào')),
          ),
        ),

        // Input area: avatar + text field + send button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Row(
            children: [
              // Placeholder avatar of current user
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).primaryColorLight,
                child: const Icon(Icons.person, size: 18, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: const InputDecoration(
                          hintText: 'Viết bình luận...',
                          border: InputBorder.none,
                          isDense: true,
                        ),
                        minLines: 1,
                        maxLines: 4,
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
                              : () =>
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text('Chưa kết nối STOMP')),
                                  ),
                          icon: Icon(
                            Icons.send,
                            color: connected
                                ? Theme.of(context).primaryColor
                                : Colors.grey,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentTile(BuildContext context, CommentEntity c) {
    final createdAt = c.createdAt;
    final hasReplies = c.repliesCount != null && c.repliesCount! > 0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
      elevation: hasReplies ? 3 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar
            _buildAvatar(c.userAvatar, c.userName),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // name + time
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          c.userName ?? 'Người dùng',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (createdAt != null)
                        Text(
                          _timeAgo(createdAt),
                          style: const TextStyle(
                              color: Colors.black54, fontSize: 12),
                        ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  // comment content
                  Text(
                    c.content ?? '',
                    style: const TextStyle(fontSize: 14),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // actions / metadata
                  Row(
                    children: [
                      if (hasReplies)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text('${c.repliesCount} trả lời',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.blue)),
                        ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // open reply flow (not implemented)
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Trả lời...')));
                        },
                        child: const Text('Trả lời'),
                        style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(String? url, String? name) {
    if (url != null && url.isNotEmpty) {
      return CircleAvatar(radius: 20, backgroundImage: NetworkImage(url));
    }

    final initials = (name ?? '')
        .trim()
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => s[0])
        .take(2)
        .join();
    return CircleAvatar(
      radius: 20,
      backgroundColor: Colors.grey.shade400,
      child: Text(initials.isEmpty ? '?' : initials,
          style: const TextStyle(color: Colors.white)),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return '${diff.inSeconds}s trước';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m trước';
    if (diff.inHours < 24) return '${diff.inHours}h trước';
    if (diff.inDays < 7) return '${diff.inDays} ngày trước';
    return '${dt.day}/${dt.month}/${dt.year}';
  }
}
