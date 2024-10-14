import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/edit_profile_controller.dart';

class EditProfileView extends GetView<EditProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Obx(() {
              return controller.isLoading.value
                  ? const LinearProgressIndicator()
                  : Container();
            }),
            const SizedBox(height: 8),

            // Profile Picture
            Center(
              child: Obx(() {
                return Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundImage:
                          controller.isProfileImageChooseSuccess.value
                              ? FileImage(controller.file)
                              : const AssetImage('images/addperson.png')
                                  as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () {
                          controller.chooseImage();
                        },
                        child: CircleAvatar(
                          backgroundColor: Colors.green[300],
                          radius: 20,
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

            const SizedBox(height: 20),
            // Full Name Field
            buildEditableField(
              'Full Name',
              controller.fullNameController,
              'Please enter your full name', // Validation message
            ),
            const SizedBox(height: 15),

            // Phone Number Field
            buildEditableField(
              'Phone Number',
              controller.phoneController,
              'Please enter a valid phone number', // Validation message
            ),
            const SizedBox(height: 30),

            // Update Button
            ElevatedButton(
              onPressed: controller.updateUserProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Update'),
            ),
          ],
        ),
      ),
    );
  }

  // Reusable Widget for Editable Fields with Validation
  Widget buildEditableField(String label, TextEditingController textcontroller,
      String validationMessage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Obx(() {
          return TextField(
            controller: textcontroller,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[200],
              errorText: controller.showError.value &&
                      controller.isEmpty(textcontroller)
                  ? validationMessage
                  : null, // Show error if invalid
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          );
        }),
      ],
    );
  }
}
