import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationCubit _notificationCubit;

  StreamSubscription<PaginationState<Item>>? _cubitSub;
  final ScrollController _listController = ScrollController();
  String? _lastTopId;

  @override
  void initState() {
    super.initState();
    _notificationCubit = sl<NotificationCubit>();
    // load initial notifications via cubit's loadInitial so states are emitted and UI updates
    _notificationCubit.loadInitial().then((_) {
      final s = _notificationCubit.state;
      if (s is PaginationSuccess<Item> && s.items.isNotEmpty) {
        // Set baseline so we don't show a snack for the initial load
        _lastTopId = s.items.first.id;
      }
    });

    // Show a small snackbar and scroll-to-top whenever the top notification changes
    _cubitSub = _notificationCubit.stream.listen((state) {
      if (state is PaginationSuccess<Item>) {
        if (state.items.isNotEmpty) {
          final top = state.items.first;
          if (top.id != _lastTopId) {
            _lastTopId = top.id;

            // show snack bar (non-blocking)
            try {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${top.title ?? ''}\n${top.message ?? ''}'),
                  action: SnackBarAction(
                    label: 'Xem',
                    onPressed: () {
                      if (top.link != null && top.link!.isNotEmpty) {
                        try {
                          Navigator.of(context).pushNamed(top.link!);
                        } catch (_) {}
                      }
                    },
                  ),
                  duration: const Duration(seconds: 5),
                ),
              );
            } catch (_) {}

            // scroll to top to reveal new notification
            try {
              _listController.animateTo(
                0.0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            } catch (_) {}
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _cubitSub?.cancel();
    _listController.dispose();
    // NotificationCubit is registered as a lazy singleton in DI, do not close it here.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
          title: 'Thông báo',
          showBack: false,
          rightIcon: IconButton(
              icon: const Icon(Icons.notifications_none_outlined),
              onPressed: () async {
                try {
                  await _notificationCubit.markAllAsRead();
                } catch (_) {}
              })),
      body: PaginationListView<Item>(
        cubit: _notificationCubit,
        controller: _listController,
        itemBuilder: (context, item) => NotificationTile(item: item),
        emptyWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_off_outlined,
                size: 64.sp,
                color: Colors.grey,
              ),
              SizedBox(height: 16.h),
              Text(
                'Không có thông báo',
                style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        errorWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.red,
              ),
              SizedBox(height: 16.h),
              Text(
                'Lỗi khi tải thông báo',
                style: TextStyle(fontSize: 16.sp, color: Colors.red[600]),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => _notificationCubit.refresh(),
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final Item item;

  const NotificationTile({super.key, required this.item});

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return DateFormat('dd/MM/yyyy HH:mm').format(dt.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final isRead = item.read ?? false;

    return InkWell(
      onTap: () async {
        // Mark as read first (if id available)
        if (item.id != null && item.id!.isNotEmpty) {
          try {
            await sl<NotificationCubit>().markAsRead(item.id!);
          } catch (_) {}
        }

        // Try to navigate to item.link if provided. Host app should register routes.
        if (item.link != null && item.link!.isNotEmpty) {
          try {
            Navigator.of(context).pushNamed(item.link!);
          } catch (_) {
            // ignore if route not found
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: isRead ? Colors.white : Colors.blue.withOpacity(0.03),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isRead ? Colors.grey[200] : Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  item.type == 'COMMENT_REPLY'
                      ? Icons.chat_bubble
                      : Icons.notifications,
                  color: isRead ? Colors.black54 : Colors.white,
                  size: 20.sp,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title ?? '',
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatDate(item.createdAt),
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.message ?? '',
                    style: TextStyle(fontSize: 14.sp, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
