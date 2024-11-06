import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/send_notification_controller.dart';

class SendNotificationView extends GetView<SendNotificationController> {
  const SendNotificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Notification Title Input
            TextField(
              controller: controller.titleController,
              decoration: const InputDecoration(
                labelText: 'Notification Title',
              ),
            ),
            const SizedBox(height: 20),
            // Notification Body Input
            TextField(
              controller: controller.bodyController,
              decoration: const InputDecoration(
                labelText: 'Notification Body',
              ),
            ),
            const SizedBox(height: 20),
            // User Token Input (Admin can input user token)

            const SizedBox(height: 30),
            // Send Notification Button
            ElevatedButton(
              onPressed: () {
                controller.sendNotification();
              },
              child: const Text('Send Notification'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Send Notification to Specific User?",
                  style: TextStyle(color: Colors.black54),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed('/send-specific-notification');
                  },
                  child: const Text(
                    'Go',
                    style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
