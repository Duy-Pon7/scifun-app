import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thilop10_3004/core/utils/theme/app_color.dart';
import 'package:thilop10_3004/features/home/presentation/cubit/dashboard_cubit.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => DashboardCubit(),
          child: const DashboardPage(),
        ),
      );

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
          selectedItemColor: AppColor.primary600,
          unselectedItemColor: AppColor.unselect,
          type: BottomNavigationBarType.fixed,
          selectedFontSize: Theme.of(context).textTheme.bodySmall!.fontSize!,
          unselectedFontSize: Theme.of(context).textTheme.bodySmall!.fontSize!,
          items: List.generate(
            context.read<DashboardCubit>().titles.length,
            (i) => BottomNavigationBarItem(
              icon: Icon(context.read<DashboardCubit>().icons[i]),
              label: context.read<DashboardCubit>().titles[i],
            ),
          ),
        ),
      ),
    );
  }
}
