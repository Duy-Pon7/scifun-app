import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:sci_fun/common/widget/app_empty_state.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/common/widget/pagination_list_view.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/presentation/cubit/notification_cubit.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late NotificationCubit _notificationCubit;

  final ScrollController _listController = ScrollController();

  @override
  void initState() {
    super.initState();
    _notificationCubit = sl<NotificationCubit>();
    _notificationCubit.ensureLoaded();
  }

  @override
  void dispose() {
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
              icon: const Icon(Symbols.notifications_none_rounded),
              onPressed: () async {
                try {
                  await _notificationCubit.markAllAsRead();
                } catch (_) {}
              })),
      body: PaginationListView<Item>(
        cubit: _notificationCubit,
        controller: _listController,
        itemBuilder: (context, item) => NotificationTile(item: item),
        emptyWidget: const Center(
          child: AppEmptyState(message: 'Không có thông báo'),
        ),
        errorWidget: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.error_outline_rounded,
                size: 64.sp,
                color: AppColor.physics500,
              ),
              SizedBox(height: 16.h),
              Text(
                'Lỗi khi tải thông báo',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColor.physics600,
                ),
              ),
              SizedBox(height: 16.h),
              ElevatedButton(
                onPressed: () => _notificationCubit.refresh(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.physics500,
                  foregroundColor: Colors.white,
                ),
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
    final accentColor = AppColor.physics500;
    final unreadBackground = AppColor.physics50;

    return InkWell(
      onTap: () async {
        final navigator = Navigator.of(context);

        // Mark as read first (if id available)
        if (item.id != null && item.id!.isNotEmpty) {
          try {
            await sl<NotificationCubit>().markAsRead(item.id!);
          } catch (_) {}
        }

        // Try to navigate to item.link if provided. Host app should register routes.
        if (item.link != null && item.link!.isNotEmpty) {
          try {
            navigator.pushNamed(item.link!);
          } catch (_) {
            // ignore if route not found
          }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        color: isRead ? Colors.white : unreadBackground,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 44.w,
              height: 44.w,
              decoration: BoxDecoration(
                color: isRead ? Colors.grey[200] : accentColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  item.type == 'COMMENT_REPLY'
                      ? Symbols.chat_bubble_rounded
                      : Symbols.notifications_rounded,
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
                            fontSize: 18.sp,
                            fontWeight:
                                isRead ? FontWeight.normal : FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        _formatDate(item.createdAt),
                        style:
                            TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    item.message ?? '',
                    style: TextStyle(fontSize: 18.sp, color: Colors.grey[800]),
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
