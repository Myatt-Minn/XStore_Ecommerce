import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  final String title;
  final String body;
  final Timestamp receivedAt;

  NotificationModel({
    required this.title,
    required this.body,
    required this.receivedAt,
  });

  factory NotificationModel.fromDocument(DocumentSnapshot doc) {
    return NotificationModel(
      title: doc['title'],
      body: doc['body'],
      receivedAt: doc['receivedAt'],
    );
  }
}
