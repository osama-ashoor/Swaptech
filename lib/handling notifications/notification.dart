import 'dart:async';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as devtools show log;
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:swaptech2/main.dart';
import 'package:swaptech2/pages/chatScreen.dart';
import 'dart:convert';

import 'package:swaptech2/pages/receivedRequestPage.dart';

class HandlingNotification {
  static late Function(int) _updateIndexCallback;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static late StreamSubscription _messageSubscription;

  Future<String> getToken() async {
    String? token = await _firebaseMessaging.getToken();
    return token!;
  }

  void createAndSetupChannel() async {
    //Create a channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'default_channel_id',
      'Main Channel',
      description: 'This channel is used for default notifications.',
      importance: Importance.high,
      enableVibration: true,
      enableLights: true,
    );
    //Setup the channel.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        if (details.payload != null) {
          Map<String, dynamic> data = json.decode(details.payload!);
          if (data['type'] == 'request accepted notification' ||
              data['type'] == 'request rejected notification') {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => ReceivedRequestPage(id: data['swapId']),
              ),
            );
          } else if (data['type'] == 'message') {
            navigatorKey.currentState!.push(
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatroomId: data['chatroomId'],
                  currentUserId: data['otherUserId'],
                  otherUserId: data['currentUserId'],
                  name: data['name'],
                  specialization: data['specialization'],
                ),
              ),
            );
          } else {
            _updateIndexCallback(2);
          }
        }
      },
    );
  }

  //Show Notification to user
  static void showNotification(RemoteNotification notification,
      Map<String, dynamic> data, BuildContext context) {
    final random = Random();
    int notificationId = random.nextInt(1000000);
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'default_channel_id',
      'Main Channel',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      autoCancel: true,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    print(data);
    String payload = json.encode(data);
    flutterLocalNotificationsPlugin.show(
      notificationId,
      notification.title,
      notification.body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  //Send Notification to specific device
  Future<bool> sendPushMessage({
    required String recipientToken,
    required String title,
    required String body,
  }) async {
    try {
      final jsonCredentials =
          await rootBundle.loadString('lib/data/swaptech-1-4c99f9cca969.json');

      final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

      final client = await auth.clientViaServiceAccount(
        creds,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final notificationData = {
        'message': {
          'token': recipientToken,
          'notification': {'title': title, 'body': body},
        },
      };

      const String senderId = '732825172085';
      final response = await client.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      client.close();

      if (response.statusCode == 200) {
        return true; // Success!
      } else {
        devtools.log(
            'Notification Sending Error Response status: ${response.statusCode}');
        devtools.log('Notification Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      devtools.log('Error occurred while sending notification: $e');
      return false;
    }
  }

  Future<bool> sendPushMessageWithData({
    required String recipientToken,
    required String title,
    required String body,
    required Map<String, dynamic> data,
  }) async {
    try {
      final jsonCredentials =
          await rootBundle.loadString('lib/data/swaptech-1-4c99f9cca969.json');

      final creds = auth.ServiceAccountCredentials.fromJson(jsonCredentials);

      final client = await auth.clientViaServiceAccount(
        creds,
        ['https://www.googleapis.com/auth/cloud-platform'],
      );

      final notificationData = {
        'message': {
          'token': recipientToken,
          'notification': {'title': title, 'body': body},
          'data': data,
        },
      };

      const String senderId = '732825172085';
      final response = await client.post(
        Uri.parse(
            'https://fcm.googleapis.com/v1/projects/$senderId/messages:send'),
        headers: {
          'content-type': 'application/json',
        },
        body: jsonEncode(notificationData),
      );

      client.close();

      if (response.statusCode == 200) {
        return true; // Success!
      } else {
        devtools.log(
            'Notification Sending Error Response status: ${response.statusCode}');
        devtools.log('Notification Response body: ${response.body}');
        return false;
      }
    } catch (e) {
      devtools.log('Error occurred while sending notification: $e');
      return false;
    }
  }

  static Future<void> init(
      BuildContext context, Function(int) updateIndex) async {
    // Handle when the app is terminated
    _updateIndexCallback = updateIndex;
    RemoteMessage? initialMessage =
        await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(context, initialMessage, updateIndex);
    }

    // Handle when the app is in background and opened from notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessage(context, message, updateIndex);
    });

    // Optional: Show a local notification when in foreground
    _messageSubscription =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showNotification(message.notification!, message.data, context);
    });
  }

  static void _handleMessage(
      BuildContext context, RemoteMessage message, Function(int) updateIndex) {
    // التحقق من الصفحة الحالية
    Route? currentRoute = ModalRoute.of(context);

    if (message.data['type'] == 'request accepted notification' ||
        message.data['type'] == 'request rejected notification') {
      if (message.data.containsKey('swapId')) {
        final String swapId = message.data['swapId'];

        // التحقق إذا كانت الصفحة الحالية هي نفس صفحة ReceivedRequestPage
        if (currentRoute?.settings.name != '/receivedRequestPage' ||
            currentRoute?.settings.arguments != swapId) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ReceivedRequestPage(id: swapId),
            ),
          );
        }
      }
    } else if (message.data['type'] == 'message') {
      if (message.data.containsKey('chatroomId')) {
        final String chatroomId = message.data['chatroomId'];
        final String currentUserId = message.data['otherUserId'];
        final String otherUserId = message.data['currentUserId'];
        final name = message.data['name'];
        final specialization = message.data['specialization'];

        // التحقق إذا كانت الصفحة الحالية هي نفس صفحة ChatScreen
        if (currentRoute?.settings.name != '/chatScreen' ||
            currentRoute?.settings.arguments != chatroomId) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatScreen(
                chatroomId: chatroomId,
                currentUserId: currentUserId,
                otherUserId: otherUserId,
                name: name,
                specialization: specialization,
              ),
            ),
          );
        }
      }
    } else {
      // تغيير currentIndex إلى 2 (علامة الطلبات)
      updateIndex(2);
    }
  }

  static void dispose() {
    // Ensure you cancel the subscription to prevent multiple triggers.
    _messageSubscription.cancel();
  }
}
