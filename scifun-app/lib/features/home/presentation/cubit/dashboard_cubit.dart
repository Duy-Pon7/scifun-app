import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sci_fun/features/analytics/presentation/page/statistics_lesson.dart';
import 'package:sci_fun/features/home/presentation/page/home_page.dart';
import 'package:sci_fun/features/leaderboards/presentation/pages/leaderboard_page.dart';
import 'package:sci_fun/features/notification/presentation/page/notification_page.dart';
import 'package:sci_fun/features/profile/presentation/page/profile_page.dart';

class DashboardCubit extends Cubit<int> {
  DashboardCubit() : super(0);

  final List<Widget> pages = [
    HomePage(),
    StatisticsLesson(),
    LeaderboardPage(subjectId: '693443de3ad457141c52aedf'),

    // ExamPage(),
    NotificationPage(),
    ProfilePage(),
  ];

  final List<String> titles = [
    'Trang chủ',
    'Thống kê',
    'Bảng xếp hạng',
    'Thông báo',
    'Tài khoản',
  ];

  final List<IconData> icons = [
    Icons.home,
    Icons.bar_chart_rounded,
    Icons.assignment,
    Icons.notifications,
    Icons.person,
  ];

  void choosePage(int index) => emit(index);
}
