import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/notification/domain/entities/notif_entity.dart';
import 'package:mediecom/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:mediecom/features/notification/presentation/bloc/notification_event.dart';
import 'package:mediecom/features/notification/presentation/bloc/notification_state.dart';

class NotificationPage extends StatefulWidget {
  static const path = '/notif-page';
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  @override
  void initState() {
    super.initState();
    context.read<NotificationBloc>().add(
      const FetchNotificationsEvent(userId: '123'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        isUserName: false,
        name: 'Notification',
        address: '',
      ),
      body: BlocBuilder<NotificationBloc, NotificationState>(
        builder: (context, state) {
          return switch (state) {
            NotificationInitial() => const SizedBox(),
            NotificationLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
            NotificationError(message: final message) => Center(
              child: Text(message, style: const TextStyle(color: Colors.red)),
            ),
            NotificationLoaded(notifications: final notifications) =>
              notifications.isEmpty
                  ? const Center(
                      child: Text(
                        "No notifications yet.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    )
                  : ListView.separated(
                      itemCount: notifications.length,
                      padding: const EdgeInsets.all(12),
                      itemBuilder: (context, index) {
                        final notif = notifications[index];
                        return _buildNotificationTile(notif);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider();
                      },
                    ),
          };
        },
      ),
    );
  }

  Widget _buildNotificationTile(NotifEntity notif) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      leading: const CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(Icons.notifications, color: Colors.white),
      ),
      title: Text(
        notif.f4Txt1 ?? "Title",
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        notif.f4Des1 ?? "Desc",
        style: const TextStyle(fontSize: 12, color: Colors.black54),
      ),
      trailing: Text(
        formatToDayMonYear(notif.f4Userdt ?? ""),
        style: const TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}

String formatToDayMonYear(String fullDateTime) {
  final dt = DateTime.parse(fullDateTime);

  // month short names
  const months = [
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec",
  ];

  String day = dt.day.toString().padLeft(2, '0');
  String month = months[dt.month - 1];
  String year = dt.year.toString();

  return "$day $month $year";
}
