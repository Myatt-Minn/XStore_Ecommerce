import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print(message.data);
}

class SendNotificationHandler {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  String? serverKeyGG;
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<String> getAccessToken() async {
    // Your client ID and client secret obtained from Google Cloud Console
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "xstore-faa86",
      "private_key_id": "bdae6cf9ae40afea216c29b01ac96654cf4ce15b",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDEK1mdtsrVGIwA\n7D3BaNShwJiKqIM4lIT/j2HABIRExyo4/KhMxyYIXgBt4dIyFO0sRqmrNlN66zQm\niXv0SjbKfwQAPJo6aErDqWUaG0cQZzdZRnYkh8/nNZNzcXK2v8wShb6Tc/PHPBV2\nuP9caXkA/JE9c1SW2QsULcJXhWvzAGtGjQU2uWfDuAWjSmHr/dYGGW4X+NrKDiMC\n4WiEV6H1QfvPqbgdcPesmaivkBplwFZCbqg9+vFY0oaxeH5XgA0OM/09V1TbzC79\nD0jE6jWZDaGTzsQ5ElMMW5NJmtP7CTGKuz9H9O/AlNHTDGo9ce3aDyL9DC4N9bRn\nqTh7XRO3AgMBAAECggEARzi99qbRCYE6A3PCECBxYrC8MUtxKO+zQd3azY5WP2pY\nCAyjRgzf4BXQ7hQY7pnuai7VlxXIRU5zxrIP0OfI8Mggub1G+YG380XjMRFKQchX\nrhAJAMZWU0l+WWGNFpCYFPl98acdkO5dlJciD3kzt4n7aWYgBgyTGyZp8sC8KqMO\n3f+dnqTDB1GEkII00I+x5ZMcao1EiVw1RPuEw4bkQ2v6sQCj4CAKd7oUEXmog7Vk\n2/W4A2a9I2NtnORCDH+gWvKTgPsnQ/YNk6LC7fBWiW8xSyPOIPNqjSRnmWEJK10s\noRMQ0tXcWZwbPUDmbUv7OJuMw6rxz5vnnVrGWEXpIQKBgQD2L7xkaxkIWjL5wx2R\nb/z2T9LTviKKW2o4zz1cVDImzE7aHKqJEQObGBtaJCC+sKfbCH4yDN2hOI7Hata3\nbe7Ch8lBxFM10nzMit8+TEL0IDA1EQTy36cBC/gtqPkcEiSzbvNcvbi/eh0F8A+X\nTxD9M0gM+dUG7WSDd1Tek+XbuQKBgQDL/TQLprKJli9taqgkOWvQRRoEhkZ52P7z\na47E3bbseHTMThsgUm0eWjd4vw9HxFpXiOz/YPZnEBk3fmL0rE8oMpgb5leWRvz0\nNmgs5IJ0beTGc+LUYA06MlJCukC7EY7UVB5H6Zh8+KHgZnYU3DwNdTEcsQqNM+o4\nOEgW0jmC7wKBgDgrkhdzXCXMtr7H5vItFBF7CwZm5midDPJjToPHbh3uFbusOLjH\nWgREDtGVVqdLlTDjki+HQfYr+l/Dn7QAcC6QXroTukyYdwMQWHlVWx1qTrV86Z0k\nrG0PtxNr71KZTShnkz1AyGtfyEl3iYcjciPjVHgpdJJ9Dab1Tjbulc55AoGBAIv5\nzLvuAHdPGm5fkM+Co4u/zzGpnjTAhXotpUNLzNkJc0Q6mHyecwgv6f6uRGL/xupo\nKBC5zXs9XcBptqekkZDI3v3OGu4g+jTuHKApkacpPaI8JTuMSadUnoPxYLe9PaBP\ntJOuJJgk2JeuV3rLAV5Ou4uvpMjuBdvcKwOV8Cb7AoGABln53JVcWnfI34rGPneX\nXgm3spSyJ3JtRm/1QVFa9+gL7wGEW2bslE6Yqs1wY1hzJ5+UtD68N1Mb/IH9zNlg\nSv0/35NU/C1UbW4AaYqR0w2T82wofIGVtJOFypREqcHm6Q+U1+yzq0plzxov7Kf4\n6iTWEtVfnz98IfpjY0QZxAU=\n-----END PRIVATE KEY-----\n",
      "client_email": "xstore@xstore-faa86.iam.gserviceaccount.com",
      "client_id": "101895402215285374982",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/xstore%40xstore-faa86.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    http.Client client = await auth.clientViaServiceAccount(
      auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
      scopes,
    );

    auth.AccessCredentials credentials =
        await auth.obtainAccessCredentialsViaServiceAccount(
            auth.ServiceAccountCredentials.fromJson(serviceAccountJson),
            scopes,
            client);

    client.close();
    return credentials.accessToken.data;
  }

  Future<void> getKey() async {
    serverKeyGG = await getAccessToken();
    print(serverKeyGG);
  }

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;

    Get.toNamed('/notification');
  }

  Future initPushNotification() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);

    await FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    FirebaseMessaging.onMessage.listen((message) async {
      if (message.notification != null) {
        print(message.notification!.title);
        print(message.notification!.body);
        print(message.data);
        // Local Notification Code to Display Alert
        displayNotification(message);

        print('GG');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }

  Future<void> initNotification() async {
    await messaging.requestPermission();
    final fCMToken = await messaging.getToken();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "token": fCMToken,
    }, SetOptions(merge: true));
    print("Token $fCMToken");

    initPushNotification();
  }

  static void displayNotification(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const notificationDetails = NotificationDetails(
        android: AndroidNotificationDetails(
            "push_notification_demo", "push_notification_demo_channel",
            importance: Importance.max, priority: Priority.high),
      );

      await flutterLocalNotificationsPlugin.show(
          id,
          message.notification!.title,
          message.notification!.body,
          notificationDetails,
          payload: json.encode(message.data));
    } on Exception catch (e) {
      print(e);
    }
  }

  static void initialized() {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    flutterLocalNotificationsPlugin.initialize(
        const InitializationSettings(android: initializationSettingsAndroid),
        onDidReceiveNotificationResponse: (details) {
      print(details.toString());
      print("localBackgroundHandler :");
      print(details.notificationResponseType ==
              NotificationResponseType.selectedNotification
          ? "selectedNotification"
          : "selectedNotificationAction");
      print(details.payload);

      try {
        var payloadObj = json.decode(details.payload ?? "{}") as Map? ?? {};
      } catch (e) {
        print(e);
      }
    }, onDidReceiveBackgroundNotificationResponse: localBackgroundHandler);
  }

  Future<void> sendPushNotificationToAllUsers(String title, String body) async {
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<String> tokens = [];

      for (var doc in querySnapshot.docs) {
        String? token = doc['token'];
        if (token != null && token.isNotEmpty) {
          tokens.add(token);
        }
      }

      if (tokens.isEmpty) {
        print('No tokens found!');
        return;
      }
      // Store the notification in Firestore
      var docRef = FirebaseFirestore.instance.collection("notifications").doc();
      docRef.set({
        "id": docRef.id,
        "title": title,
        "body": body,
      });

      for (String token in tokens) {
        await sendPushNotification(token: token, title: title, body: body);
      }
    } catch (e) {
      print('Error sending notifications: $e');
    }
  }

  Future<void> sendPushNotification({
    required String token,
    required String title,
    required String body,
  }) async {
    final Uri url = Uri.parse(
        'https://fcm.googleapis.com/v1/projects/xstore-faa86/messages:send');

    final Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $serverKeyGG',
    };

    final Map<String, dynamic> payload = {
      'message': {
        'token': token,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'click_action': 'FLUTTER_NOTIFICATION_CLICK',
          'message': 'This is additional data payload',
        },
      }
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Push Notification Sent Successfully!');
      } else {
        print('Failed to send push notification: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while sending push notification: $e');
    }
  }

  static Future<void> localBackgroundHandler(NotificationResponse data) async {
    print(data.toString());
    print("localBackgroundHandler :");
    print(data.notificationResponseType ==
            NotificationResponseType.selectedNotification
        ? "selectedNotification"
        : "selectedNotificationAction");
    print(data.payload);

    try {
      var payloadObj = json.decode(data.payload ?? "{}") as Map? ?? {};
      // openNotification(payloadObj);
    } catch (e) {
      print(e);
    }
  }
}
