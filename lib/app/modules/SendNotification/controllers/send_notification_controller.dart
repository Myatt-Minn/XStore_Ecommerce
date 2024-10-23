import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/sendNotificationHandler.dart';

class SendNotificationController extends GetxController {
  //TODO: Implement SendNotificationController
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  final TextEditingController tokenController = TextEditingController();

  final SendNotificationHandler notificationHandler = SendNotificationHandler();

  @override
  void onInit() async {
    await notificationHandler.getKey();
    super.onInit();
  }

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    tokenController.dispose();
    super.onClose();
  }

  void sendNotification() {
    String title = titleController.text.trim();
    String body = bodyController.text.trim();

    if (title.isEmpty || body.isEmpty) {
      Get.snackbar('Error', 'Please fill out all fields');
      return;
    }

    notificationHandler
        .sendPushNotificationToAllUsers(title, body)
        .then((_) => Get.snackbar('Success', 'Notification sent successfully'))
        .catchError((error) {
      return Get.snackbar('Error', 'Failed to send notification: $error');
    });
  }
}
