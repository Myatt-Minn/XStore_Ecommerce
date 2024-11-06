import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and Username Section
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade300,
                        backgroundImage: controller.profileImg.value.isNotEmpty
                            ? NetworkImage(controller.profileImg.value)
                            : null,
                        child: controller.profileImg.value.isEmpty
                            ? Image.asset(
                                'images/person.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              )
                            : null,
                      );
                    }),
                    const SizedBox(height: 10),
                    // Username
                    Obx(
                      () => Text(
                        controller.username.value,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 30),

              // Account Setting Section
              const Text(
                'Account Setting',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              SettingOption(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () => Get.toNamed('/edit-profile'),
              ),
              SettingOption(
                icon: Icons.history,
                label: 'Order History',
                onTap: () => Get.toNamed('/order-history'),
              ),
              SettingOption(
                icon: Icons.delete_outline,
                label: 'Delete Account',
                onTap: () {
                  // Confirm Deletion Dialog
                  Get.dialog(
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      title: const Text(
                        'Confirm Deletion',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      content: Text(
                        'Are you sure you want to delete this account?',
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                      actions: [
                        TextButton(
                          onPressed: Get.back,
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            controller.deleteUser();
                            Get.back();
                            controller.signOut();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                    barrierDismissible: false,
                  );
                },
              ),
              const Divider(height: 30),

              // App Setting Section
              const Text(
                'App Setting',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Obx(() => SwitchListTile(
                    title: const Text('Dark Mode'),
                    value: controller.goDarkMode.value,
                    onChanged: (val) => controller.toggleDarkMode(),
                    secondary: const Icon(Icons.dark_mode),
                  )),
              Obx(() => SwitchListTile(
                    title: const Text('Enable Notification'),
                    value: controller.notificationsEnabled.value,
                    onChanged: (val) => controller.toggleNotifications(),
                    secondary: const Icon(Icons.notifications),
                  )),

              const Divider(height: 30),

              // Other Options Section
              SettingOption(
                icon: Icons.description_outlined,
                label: 'Terms and Conditions',
                onTap: () {
                  Get.toNamed('/terms-and-condition');
                },
              ),
              SettingOption(
                icon: Icons.privacy_tip_outlined,
                label: 'Privacy Policy',
                onTap: () {
                  Get.toNamed('/privacy-policy');
                },
              ),
              SettingOption(
                  icon: Icons.call,
                  label: 'Call Center',
                  onTap: controller.makePhoneCall),

              // Footer Section
              const SizedBox(height: 20),
              ListTile(
                title: const Text(
                  'Sign Out',
                  style: TextStyle(color: ConstsConfig.primarycolor),
                ),
                leading:
                    const Icon(Icons.logout, color: ConstsConfig.primarycolor),
                onTap: () => controller.signOut(),
              ),
              const SizedBox(height: 20),
              Center(
                child: GestureDetector(
                  onTap: controller.goToWebsite,
                  child: Text(
                    '© 2024 App.com.mm. All rights reserved.',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SettingOption({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
