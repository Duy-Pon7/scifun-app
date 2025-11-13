import 'package:thilop10_3004/features/notification/domain/entities/notification.dart';

class NotificationGroupByDate {
  final String date;
  final List<Notification> notifications;

  NotificationGroupByDate({
    required this.date,
    required this.notifications,
  });
}
