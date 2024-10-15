import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/account_controller.dart';

class AccountView extends GetView<AccountController> {
  const AccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person),
        title: const Text('Account',
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Obx(() {
                      return Container(
                        width:
                            120, // Set the width of the circle (equivalent to radius 60)
                        height: 120, // Set the height of the circle
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: controller.profileImg.value.isEmpty
                            ? const Icon(
                                Icons
                                    .person, // Show an icon as a placeholder when there's no image
                                size: 60,
                              )
                            : FancyShimmerImage(
                                imageUrl: controller.profileImg.value,
                                boxFit: BoxFit.cover,
                                width: 120,
                                height: 120,
                                errorWidget: const Icon(
                                  Icons
                                      .error, // Placeholder in case of an error
                                  size: 60,
                                ),
                              ),
                      );
                    }),
                    const SizedBox(height: 10),
                    // User Name
                    Obx(
                      () => Text(
                        controller.username
                            .value, // Replace with dynamic data if needed
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              const Text('Account Setting', style: TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              SettingOption(
                icon: Icons.person_outline,
                label: 'Profile',
                onTap: () {
                  Get.toNamed('/edit-profile');
                },
              ),
              SettingOption(
                icon: Icons.history,
                label: 'Order History',
                onTap: () {
                  Get.toNamed('/order-history');
                },
              ),
              SettingOption(
                icon: Icons.delete_outline,
                label: 'Delete Account',
                onTap: () {
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
                          onPressed: () {
                            // Close the dialog without doing anything
                            Get.back();
                          },
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
                            backgroundColor: Colors.red, // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                          ),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                    barrierDismissible:
                        false, // Prevent dismissing by tapping outside
                  );
                },
              ),
              const SizedBox(height: 20),
              const Text('App Setting', style: TextStyle(fontSize: 16)),
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
              // ListTile(
              //   title: const Text('Language'),
              //   subtitle: Obx(() => Text(controller.languageSelected.value)),
              //   trailing: const Icon(Icons.arrow_forward_ios),
              //   onTap: () {
              //     // Show a dialog or dropdown to change the language
              //     _showLanguageSelectionDialog(context);
              //   },
              // ),
              const SizedBox(height: 20),
              ListTile(
                title: const Text('Sign Out',
                    style: TextStyle(color: Colors.green)),
                leading: const Icon(Icons.logout, color: Colors.green),
                onTap: () => controller.signOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void _showLanguageSelectionDialog(BuildContext context) {
  //   Get.defaultDialog(
  //     title: 'Select Language',
  //     content: Column(
  //       children: [
  //         ListTile(
  //           title: const Text('English'),
  //           onTap: () {
  //             controller.changeLanguage('English');
  //             Get.back();
  //           },
  //         ),
  //         ListTile(
  //           title: const Text('Spanish'),
  //           onTap: () {
  //             controller.changeLanguage('Spanish');
  //             Get.back();
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
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
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}
