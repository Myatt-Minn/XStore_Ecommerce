import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controllers/send_specific_notification_controller.dart';

class SendSpecificNotificationView
    extends GetView<SendSpecificNotificationController> {
  const SendSpecificNotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Notification'),
      ),
      body: SingleChildScrollView(
        // Wrap the content in SingleChildScrollView for scrolling
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              // User Token Input
              TextField(
                controller: controller.tokenController,
                decoration: const InputDecoration(
                  labelText: 'User Token',
                ),
              ),
              const SizedBox(height: 30),
              // Send Notification Button
              ElevatedButton(
                onPressed: () {
                  controller.sendNotificationToUser();
                },
                child: const Text('Send Notification'),
              ),
              const SizedBox(height: 30),
              const Text(
                'Select a token by copying it from the table below:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              // Displaying usernames and tokens in a table
              Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.users.isEmpty) {
                  return const Text('No users found.');
                }
                return Table(
                  border: TableBorder.all(),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Username column
                    1: FlexColumnWidth(3), // Token column
                  },
                  children: [
                    const TableRow(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Username',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Token',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    ...controller.users.map((user) {
                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(user['name']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                // Copy the token to the clipboard and notify the admin
                                Clipboard.setData(
                                    ClipboardData(text: user['token']));
                                Get.snackbar(
                                    'Copied', 'Token copied to clipboard');
                              },
                              child: Text(
                                user['token'],
                                style: const TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
