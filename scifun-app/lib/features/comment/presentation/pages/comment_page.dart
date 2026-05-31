import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/services/realtime_service.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/comment/data/model/comment_model.dart';
import 'package:sci_fun/features/comment/domain/entity/comment_entity.dart';
import 'package:sci_fun/features/comment/presentation/cubit/comment_pagination_cubit.dart';
import 'package:sci_fun/features/profile/presentation/cubit/user_cubit.dart';

class CommentPage extends StatefulWidget {
  const CommentPage({super.key});

  @override
  State<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  Color get _forumCyan => AppColor.skyblue400;
  Color get _forumBlue => AppColor.skyblue600;
  Color get _forumDeep => AppColor.skyblue800;
  Color get _forumSurface => AppColor.skyblue50;
  Color get _forumTint => AppColor.skyblue100;

  final TextEditingController _controller = TextEditingController();
  late final CommentPaginationCubit _commentPaginationCubit;
  StreamSubscription<Map<String, dynamic>>? _commentSub;
  StreamSubscription<Map<String, dynamic>>? _notificationSub;
  bool _hasInput = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onComposerChanged);

    _commentPaginationCubit = sl<CommentPaginationCubit>();
    _commentPaginationCubit.loadInitial();

    _commentSub = RealtimeService.I.commentStream.listen((commentPayload) {
      try {
        final comment = CommentModel.fromJson(commentPayload);
        _commentPaginationCubit.insertNewComment(comment);
      } catch (e) {
        debugPrint('Invalid realtime comment payload: $e');
      }
    });

    _notificationSub =
        RealtimeService.I.notificationStream.listen((notificationPayload) {
      debugPrint('NOTI: $notificationPayload');
    });
  }

  void _onComposerChanged() {
    final bool nextHasInput = _controller.text.trim().isNotEmpty;
    if (nextHasInput != _hasInput && mounted) {
      setState(() {
        _hasInput = nextHasInput;
      });
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onComposerChanged);
    _controller.dispose();
    _commentSub?.cancel();
    _notificationSub?.cancel();
    _commentPaginationCubit.close();
    super.dispose();
  }

  void _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    final messenger = ScaffoldMessenger.of(context);

    try {
      final success =
          await RealtimeService.I.sendNewComment(content: text, parentId: null);
      if (success) {
        _controller.clear();
      } else {
        if (!mounted) return;
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
                'Khong the gui binh luan, vui long thu lai khi ket noi on dinh'),
          ),
        );
      }
    } catch (e, st) {
      debugPrint('Unexpected error when sending comment: $e\\n$st');
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Loi khi gui binh luan, thu lai sau'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.74),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: _forumCyan.withValues(alpha: 0.22),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            _buildForumHeader(),
            const SizedBox(height: 12),
            SizedBox(
              height: 340,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: _forumSurface.withValues(alpha: 0.58),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: _forumCyan.withValues(alpha: 0.18),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
                  child: PaginationListView<CommentEntity>(
                    cubit: _commentPaginationCubit,
                    itemBuilder: (context, c) => _buildCommentTile(c),
                    emptyWidget: const Center(
                      child: AppEmptyState(
                        message: 'Chưa có bình luận nào',
                        animationSize: 120,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildComposer(context),
          ],
        ),
      ),
    );
  }

  Widget _buildForumHeader() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _forumCyan,
            _forumBlue,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: _forumBlue.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 52,
            top: -38,
            child: Container(
              width: 86,
              height: 86,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.14),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Diễn đàn',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Bình luận',
                      style: TextStyle(
                        color: Colors.black.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    StreamBuilder<bool>(
                      stream: RealtimeService.I.connectionStream,
                      initialData: RealtimeService.I.isConnected,
                      builder: (context, snap) {
                        final connected = snap.data ?? false;
                        return _buildRealtimeChip(connected);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.94),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Cùng chia sẻ góc nhìn khoa học của bạn',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: _forumDeep.withValues(alpha: 0.72),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRealtimeChip(bool connected) {
    final Color chipColor = connected ? _forumBlue : const Color(0xFFD64242);
    final IconData chipIcon =
        connected ? Symbols.cloud_done_rounded : Symbols.cloud_off_rounded;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.42),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            chipIcon,
            color: chipColor,
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            connected ? 'Realtime' : 'Offline',
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComposer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: _forumCyan.withValues(alpha: 0.24),
        ),
        boxShadow: [
          BoxShadow(
            color: _forumBlue.withValues(alpha: 0.12),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildComposerAvatar(context),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Viết bình luận...',
                hintStyle: TextStyle(
                  color: Colors.grey.shade500,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
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
              final canSend = connected && _hasInput;

              return DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: canSend
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [_forumCyan, _forumBlue],
                        )
                      : null,
                  color: canSend ? null : Colors.grey.shade300,
                  boxShadow: canSend
                      ? [
                          BoxShadow(
                            color: _forumBlue.withValues(alpha: 0.24),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: IconButton(
                  onPressed: !connected
                      ? () => ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Chưa kết nối STOMP')),
                          )
                      : canSend
                          ? _send
                          : null,
                  icon: Icon(
                    Symbols.send_rounded,
                    color: canSend ? Colors.white : Colors.grey.shade500,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarRing({
    required Widget child,
    required bool highlight,
  }) {
    final List<Color> ringColors = highlight
        ? [
            _forumCyan.withValues(alpha: 0.9),
            _forumBlue.withValues(alpha: 0.9),
          ]
        : [
            Colors.grey.shade300,
            Colors.grey.shade200,
          ];

    return Container(
      width: 46,
      height: 46,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: ringColors,
        ),
      ),
      child: child,
    );
  }

  Widget _buildCommentTile(CommentEntity c) {
    final DateTime? createdAt = c.createdAt;
    final bool hasReplies = c.repliesCount != null && c.repliesCount! > 0;
    final Color borderColor =
        hasReplies ? _forumCyan.withValues(alpha: 0.32) : Colors.grey.shade300;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
        ),
        boxShadow: [
          BoxShadow(
            color: _forumBlue.withValues(alpha: hasReplies ? 0.14 : 0.07),
            blurRadius: hasReplies ? 16 : 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAvatar(c.userAvatar, c.userName, highlight: hasReplies),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        c.userName ?? 'Người dùng',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Color(0xFF111827),
                        ),
                      ),
                    ),
                    if (createdAt != null)
                      Text(
                        _timeAgo(createdAt),
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  c.content ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 1.3,
                    color: Color(0xFF1F2937),
                  ),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                if (hasReplies) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: _forumCyan.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${c.repliesCount} phản hồi',
                      style: TextStyle(
                        color: _forumBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatar(
    String? url,
    String? name, {
    bool highlight = false,
  }) {
    if (url != null && url.isNotEmpty) {
      return _buildAvatarRing(
        highlight: highlight,
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade200,
          child: ClipOval(
            child: Image.network(
              url,
              width: 42,
              height: 42,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildAvatarFallback(name),
            ),
          ),
        ),
      );
    }

    return _buildAvatarRing(
      highlight: highlight,
      child: _buildAvatarFallback(name),
    );
  }

  Widget _buildAvatarFallback(String? name) {
    final initials = (name ?? '')
        .trim()
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => s[0])
        .take(2)
        .join();

    return CircleAvatar(
      backgroundColor: _forumTint,
      child: Text(
        initials.isEmpty ? '?' : initials.toUpperCase(),
        style: TextStyle(
          color: _forumBlue,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildComposerAvatar(BuildContext context) {
    UserCubit? userCubit;
    try {
      userCubit = BlocProvider.of<UserCubit>(context);
    } catch (_) {
      userCubit = null;
    }

    if (userCubit == null) {
      return _buildCurrentUserAvatar(context, null, null);
    }

    return BlocBuilder<UserCubit, UserState>(
      bloc: userCubit,
      builder: (context, state) {
        if (state is UserLoaded) {
          return _buildCurrentUserAvatar(
            context,
            state.user.data?.avatar,
            state.user.data?.fullname,
          );
        }
        return _buildCurrentUserAvatar(context, null, null);
      },
    );
  }

  Widget _buildCurrentUserAvatar(
    BuildContext context,
    String? avatarUrl,
    String? fullName,
  ) {
    final trimmedUrl = (avatarUrl ?? '').trim();
    if (trimmedUrl.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: Colors.grey.shade200,
        child: ClipOval(
          child: Image.network(
            trimmedUrl,
            width: 36,
            height: 36,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _buildCurrentUserFallback(context),
          ),
        ),
      );
    }

    final initials = (fullName ?? '')
        .trim()
        .split(' ')
        .where((s) => s.isNotEmpty)
        .map((s) => s[0])
        .take(2)
        .join();

    if (initials.isNotEmpty) {
      return CircleAvatar(
        radius: 18,
        backgroundColor: _forumBlue,
        child: Text(
          initials.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      );
    }

    return _buildCurrentUserFallback(context);
  }

  Widget _buildCurrentUserFallback(BuildContext context) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: _forumBlue,
      child: const Icon(Symbols.person_rounded, size: 18, color: Colors.white),
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
