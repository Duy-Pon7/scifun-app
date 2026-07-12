import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/common/cubit/pagination_cubit.dart';
import 'package:sci_fun/core/di/injection.dart';
import 'package:sci_fun/core/utils/theme/app_color.dart';
import 'package:sci_fun/features/home/presentation/cubit/dashboard_cubit.dart';
import 'package:sci_fun/features/notification/domain/entity/notification_entity.dart';
import 'package:sci_fun/features/notification/presentation/cubit/notification_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static route() {
    sl<NotificationCubit>().ensureLoaded();
    return MaterialPageRoute(
      builder: (context) => BlocProvider(
        create: (context) => DashboardCubit(),
        child: const DashboardPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardCubit, int>(
      builder: (context, index) => Scaffold(
        body: IndexedStack(
          index: index,
          children:
              context.read<DashboardCubit>().pages.map((page) => page).toList(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: index,
          onTap: context.read<DashboardCubit>().choosePage,
          selectedItemColor: AppColor.skyblue600,
          unselectedItemColor: AppColor.unselect,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: Theme.of(context).textTheme.bodySmall!.fontSize!,
          unselectedFontSize: Theme.of(context).textTheme.bodySmall!.fontSize!,
          items: List.generate(
            context.read<DashboardCubit>().titles.length,
            (i) => BottomNavigationBarItem(
              icon: i == 3
                  ? const _NotificationBottomNavIcon()
                  : Icon(context.read<DashboardCubit>().icons[i]),
              label: context.read<DashboardCubit>().titles[i],
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationBottomNavIcon extends StatelessWidget {
  const _NotificationBottomNavIcon();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NotificationCubit, PaginationState<Item>>(
      bloc: sl<NotificationCubit>(),
      builder: (context, state) {
        final unreadCount =
            state.items.where((item) => item.read != true).length;
        final badgeText = unreadCount > 99 ? '99+' : '$unreadCount';

        return Stack(
          clipBehavior: Clip.none,
          children: [
            Icon(context.read<DashboardCubit>().icons[3]),
            if (unreadCount > 0)
              Positioned(
                top: -6,
                right: -12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(9)),
                  ),
                  child: Center(
                    child: Text(
                      badgeText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
