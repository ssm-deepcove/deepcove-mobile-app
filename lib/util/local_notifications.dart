import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'hex_color.dart';

class LocalNotifications {
  static FlutterLocalNotificationsPlugin notifications;
  static BuildContext context;

  static initlizeNotifications() {
    notifications = FlutterLocalNotificationsPlugin();

    var initializationSettingsAndroid = AndroidInitializationSettings('icon');

    var initializationSettings =
        InitializationSettings(initializationSettingsAndroid, null);

    notifications.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  static Future onSelectNotification(String payload) async {
    if (payload != null) {
      print('notification payload: ' + payload);
    }
    await Navigator.of(context).pushNamed('/noticeboard');
  }

  static NotificationDetails get _ongoing {
    final androidChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: true,
      color: HexColor("FF8BC34A"),
    );

    return NotificationDetails(androidChannelSpecifics, null);
  }

  static Future showOngoingNotification({
    @required String title,
    @required String body,
    @required String payload,
    @required BuildContext cntxt,
    int id = 0,
  }) {
    context = context;

    return showNotification(
        title: title, body: body, id: id, type: _ongoing, payload: payload);
  }

  static Future showNotification({
    @required String title,
    @required String body,
    @required NotificationDetails type,
    @required String payload,
    int id = 0,
  }) =>
      notifications.show(id, title, body, type, payload: payload);
}
