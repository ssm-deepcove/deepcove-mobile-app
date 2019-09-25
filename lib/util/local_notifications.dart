import 'package:discover_deep_cove/views/settings/noticeboard/noticeboard.dart';
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
    switch(payload){
      case "Notice":
          await Navigator.of(context).pushNamed('/noticeboard');
          break;

      case "Content":
        //TODO: decide which route to pass
    }
    
  }

  static NotificationDetails get _notice {
    final androidChannelSpecifics = AndroidNotificationDetails(
      '0',
      'Notices',
      'New notice notification',
      importance: Importance.Max,
      priority: Priority.High,
      ongoing: true,
      autoCancel: true,
      color: HexColor("FF8BC34A"),
    );

    return NotificationDetails(androidChannelSpecifics, null);
  }

  static NotificationDetails get _download {
    final androidChannelSpecifics = AndroidNotificationDetails(
      '1',
      'New content',
      'New content available notification',
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
    context = cntxt;

    return showNotification(
        title: title, body: body, id: id, type: payload == "Notice" ? _notice : _download, payload: payload);
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
