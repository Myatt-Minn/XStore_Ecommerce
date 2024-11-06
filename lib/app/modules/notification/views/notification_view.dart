import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.offAndToNamed('/navigation-screen'),
        ),
        backgroundColor: ConstsConfig.primarycolor,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() => ElevatedButton(
                      onPressed: () {
                        controller.toggleNotificationView();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstsConfig.secondarycolor,
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(
                        controller.isViewingAllNotifications.value
                            ? 'View My Notifications'
                            : 'View All Notifications',
                        style: TextStyle(color: Colors.white),
                      ),
                    )),
              ],
            ),
          ),
          Expanded(
            child: Obx(() {
              final notifications = controller.isViewingAllNotifications.value
                  ? controller.notifications
                  : controller.usernotifications;

              if (notifications.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      "No notifications yet",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notification = notifications[index];

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: const Icon(
                        Icons.notifications,
                        color: Color(0xFF95CCA9),
                        size: 36,
                      ),
                      title: Text(
                        notification.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          notification.body,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                      trailing: controller.isViewingAllNotifications.value
                          ? null
                          : IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                // Call the delete function here
                                controller.deleteNotification(notification);
                              },
                            ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
