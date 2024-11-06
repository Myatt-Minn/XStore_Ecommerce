import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:xstore/app/data/sendNotificationHandler.dart';

class SendSpecificNotificationController extends GetxController {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  final SendNotificationHandler notificationHandler = SendNotificationHandler();

  var isLoading = false.obs;
  var users = [].obs; // List to store users with tokens

  @override
  void onInit() async {
    super.onInit();
    await notificationHandler.getKey();
    fetchUsersWithTokens();
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    tokenController.dispose();
    super.onClose();
  }

  // Fetch users with tokens from Firestore
  void fetchUsersWithTokens() async {
    isLoading.value = true;
    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      List<Map<String, dynamic>> fetchedUsers = [];

      for (var doc in querySnapshot.docs) {
        String? token = doc['token'];
        String? username = doc['name'];
        String? uid =
            doc['uid']; // Assuming there's a 'username' field in Firestore

        if (token != null && token.isNotEmpty) {
          fetchedUsers
              .add({'name': username ?? 'Unknown', 'token': token, 'uid': uid});
        }
      }

      users.value = fetchedUsers;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch users: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Send notification to a specific user
  void sendNotificationToUser() async {
    String title = titleController.text.trim();
    String body = bodyController.text.trim();
    String token = tokenController.text.trim();

    if (title.isEmpty || body.isEmpty || token.isEmpty) {
      Get.snackbar('Error', 'Please fill out all fields');
      return;
    }
// Find the user with the entered token
    Map<String, dynamic>? user =
        users.firstWhereOrNull((user) => user['token'] == token);

    if (user == null) {
      Get.snackbar('Error', 'Invalid token');
      return;
    }

    try {
      // After sending, store the notification in Firestore
      await storeNotificationInFirestore(
          userId: user['uid'], title: title, body: body);

      Get.snackbar('Success', 'Notification sent and stored successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to send notification: $e');
    }
    notificationHandler
        .sendPushNotification(token: token, title: title, body: body)
        .then((_) => Get.snackbar('Success', 'Notification sent successfully'))
        .catchError((error) {
      return Get.snackbar('Error', 'Failed to send notification: $error');
    });
  }

  // Store notification data in the user's document
  Future<void> storeNotificationInFirestore({
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      var uuid = const Uuid();
      String uuidString = uuid.v4();
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'notifications': FieldValue.arrayUnion([
          {
            'id': uuidString,
            'title': title,
            'body': body,
          }
        ])
      });
    } catch (e) {
      print('Error storing notification in Firestore: $e');
      rethrow;
    }
  }
}
