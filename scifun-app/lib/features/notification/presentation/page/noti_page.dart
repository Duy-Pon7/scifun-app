import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sci_fun/common/cubit/paginator_cubit.dart';
import 'package:sci_fun/common/widget/basic_appbar.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/assets/app_image.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/notification/data/models/noti_model.dart';
import 'package:sci_fun/features/notification/domain/usecases/get_notification.dart';
import 'package:sci_fun/features/notification/presentation/components/noti_of_day.dart';
import 'package:sci_fun/features/notification/presentation/cubit/noti_cubit.dart';
import 'package:sci_fun/features/notification/presentation/cubit/notification_paginator_cubit.dart';
import 'package:sci_fun/features/notification/presentation/widget/noti_item.dart';

class NotiPage extends StatefulWidget {
  const NotiPage({super.key});

  @override
  State<NotiPage> createState() => _NotiPageState();
}

class _NotiPageState extends State<NotiPage>
    with AutomaticKeepAliveClientMixin {
  late final PaginatorCubit<NotiModel, dynamic> _notiPaginator;
  late final ScrollController _scrollCon;

  @override
  void initState() {
    _notiPaginator = PaginatorCubit<NotiModel, dynamic>(
      usecase: sl<GetNotifications>(),
    )..paginateData();

    // Listen scroll action
    _scrollCon = ScrollController()
      ..addListener(() {
        if (_scrollCon.position.pixels == _scrollCon.position.maxScrollExtent) {
          _notiPaginator.paginateData();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    _notiPaginator.close();
    _scrollCon.dispose();
    super.dispose();
  }

  Map<DateTime, List<NotiModel>> _groupNotificationsByDate(
      List<NotiModel> notifications) {
    Map<DateTime, List<NotiModel>> grouped = {};

    for (var noti in notifications) {
      final createdAt = noti.createdAt ?? DateTime.now();
      final date = DateTime(createdAt.year, createdAt.month, createdAt.day);

      if (!grouped.containsKey(date)) {
        grouped[date] = [];
      }
      grouped[date]!.add(noti);
    }

    return grouped;
  }

  // Implement navigate to notification-detail
  // void _onNavigate(BuildContext context, {int? id, int? status}) {
  //   if (id != null) {
  //     Navigator.push(
  //       context,
  //       slidePage(
  //         BlocProvider.value(
  //           value: context.read<PaginatorCubit<NotiModel, dynamic>>(),
  //           child: NotiDetailPage(),
  //         ),
  //         settings: RouteSettings(name: 'NotiDetail'),
  //       ),
  //     );
  //   }
  // }
  bool _hasUnread(List<NotiModel> notis) {
    return notis
        .any((noti) => noti.status == 1); // Giả sử status == 1 là chưa đọc
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _notiPaginator),
        BlocProvider(create: (context) => sl<NotificationPaginatorCubit>()),
        BlocProvider(create: (context) => sl<NotiCubit>())
      ],
      child: Scaffold(
        appBar: BasicAppbar(
          title: Text(
            "Thông báo",
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w600,
                ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<PaginatorCubit<NotiModel, dynamic>,
                PaginatorState<NotiModel>>(
              builder: (context, state) {
                final notis =
                    context.read<PaginatorCubit<NotiModel, dynamic>>().items;
                final hasUnread = _hasUnread(notis);

                return IconButton(
                  icon: Icon(
                    Icons.done_all_rounded,
                    color: hasUnread
                        ? AppColor.primary600
                        : Colors.grey, // Đổi màu
                  ),
                  onPressed: hasUnread
                      ? () async {
                          await context
                              .read<NotiCubit>()
                              .markNotificationAsReadAll();
                          await context
                              .read<PaginatorCubit<NotiModel, dynamic>>()
                              .refreshData();
                        }
                      : null, // Disable nếu không còn thông báo chưa đọc
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            // Unread notifcations quantity
            // UnreadQuantity(),

            // Notification list
            Expanded(
              child: BlocBuilder<PaginatorCubit<NotiModel, dynamic>,
                  PaginatorState<NotiModel>>(
                builder: (context, state) {
                  print(state);
                  if (state is PaginatorLoading<NotiModel>) {
                    return CustomizeLoader();
                  } else if (state is PaginatorLoaded<NotiModel> ||
                      state is PaginatorLoadMore<NotiModel>) {
                    final notifications = context
                        .read<PaginatorCubit<NotiModel, dynamic>>()
                        .items;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      _onLoadMoreWhenTheContentUnOccupiesTheWholePage();
                    });
                    return Column(
                      children: [
                        Expanded(
                          child: RefreshIndicator.adaptive(
                            color: AppColor.primary500,
                            onRefresh: () async => await context
                                .read<PaginatorCubit<NotiModel, dynamic>>()
                                .refreshData(),
                            child: Visibility(
                              visible: notifications.isNotEmpty,
                              replacement: CustomizeTryAgain(
                                error: "Chưa có thông báo nào",
                                onPressed: () async => await context
                                    .read<PaginatorCubit<NotiModel, dynamic>>()
                                    .refreshData(),
                              ),
                              child: Builder(
                                builder: (context) {
                                  final groupedNotifications =
                                      _groupNotificationsByDate(notifications);
                                  final sortedDates = groupedNotifications.keys
                                      .toList()
                                    ..sort((a, b) => b.compareTo(
                                        a)); // Ngày mới nhất lên trước

                                  return ListView.builder(
                                    controller: _scrollCon,
                                    physics: const BouncingScrollPhysics(
                                        parent:
                                            AlwaysScrollableScrollPhysics()),
                                    itemCount: sortedDates.length,
                                    itemBuilder: (context, index) {
                                      final date = sortedDates[index];
                                      final notis = groupedNotifications[date]!;
                                      final items = notis.map((noti) {
                                        return NotiItem(
                                          id: noti.id,
                                          isRead: noti.status,
                                          date:
                                              noti.createdAt ?? DateTime.now(),
                                          title: noti.title ?? '',
                                          content: noti.message ?? '',
                                        );
                                      }).toList();

                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 16.w, vertical: 8.h),
                                        child: NotiOfDay(
                                            date: date, notiItems: items),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: state is PaginatorLoadMore<NotiModel>,
                          child: CustomizeLoader(),
                        ),
                      ],
                    );
                  } else if (state is PaginatorFailed<NotiModel>) {
                    // return CustomizeTryAgain(
                    //   onPressed: () async => await context
                    //       .read<PaginatorCubit<NotiModel, dynamic>>()
                    //       .refreshData(),
                    // );
                    return RefreshIndicator.adaptive(
                      color: AppColor.inputIcon,
                      onRefresh: () async => await context
                          .read<PaginatorCubit<NotiModel, dynamic>>()
                          .refreshData(),
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          Image.asset(AppImage.notifications),
                          SizedBox(height: 20.h),
                          Center(
                            child: Text(
                              "Bạn chưa có thông báo nào",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(
                                    fontSize: 22.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return Column(
                    spacing: 32.h,
                    children: [
                      Image.asset(AppImage.notifications),
                      Text(
                        "Bạn chưa có thông báo nào",
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontSize: 22.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

// When the content unoccupies the whole page
  void _onLoadMoreWhenTheContentUnOccupiesTheWholePage() {
    if (_scrollCon.position.maxScrollExtent > 0) {
      return;
    }
    if (_scrollCon.position.pixels == 0 &&
        _notiPaginator.state is PaginatorLoaded<NotiModel> &&
        !_notiPaginator.isClosed) {
      _notiPaginator.paginateData();
    }
  }
}

// class UnreadQuantity extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(vertical: 8),
//       child: Text("Bạn có 3 thông báo chưa đọc"),
//     );
//   }
// }

class CustomizeLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class CustomizeTryAgain extends StatelessWidget {
  final String? error;
  final VoidCallback onPressed;

  const CustomizeTryAgain({
    Key? key,
    this.error,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (error != null) ...[
            Text(error!, textAlign: TextAlign.center),
            SizedBox(height: 10),
          ],
          ElevatedButton(
            onPressed: onPressed,
            child: Text("Thử lại"),
          ),
        ],
      ),
    );
  }
}
