import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/account/controllers/account_controller.dart';

class EditProfileController extends GetxController {
  //TODO: Implement EditProfileController
// Firestore instance and user ID
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId =
      FirebaseAuth.instance.currentUser!.uid; // Replace with actual user ID

  // Reactive variables for the profile fields
  var fullName = ''.obs;

  var isLoading = false.obs;

  var isProfileImageChooseSuccess = false.obs;
  var profileImg = "".obs;
  late File file;

  @override
  void onReady() {
    super.onReady();
    isProfileImageChooseSuccess.value = false;
  }

  // Text controllers for the TextFields
  late TextEditingController fullNameController;
  late TextEditingController emailController;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();

    fetchUserData(); // Fetch user data when the controller initializes
  }

  // Fetch current user data from Firestore
  void fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        fullName.value = userDoc['name'];

        profileImg.value = userDoc['profilepic'];

        // Set values in TextControllers for initial state
        fullNameController.text = fullName.value;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data.');
    }
  }

  // Update user profile data in Firestore
  void updateUserProfile() async {
    try {
      isLoading.value = true;
      await uploadImage(file);
      await _firestore.collection('users').doc(userId).update({
        'name': fullNameController.text,
        'profilepic': profileImg.value,
      });

      Get.snackbar('Success', 'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);
      Get.find<AccountController>().fetchProfilePic();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile.');
    }
  }

  // Function to choose an image from File Picker
  Future<void> chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);

      isProfileImageChooseSuccess.value = true;
    } else {
      // User canceled the picker
      Get.snackbar("Cancel", "No Image");
    }
  }

// Function to upload the selected image to Firebase Storage and save its metadata in Firestore
  Future<void> uploadImage(File imageFile) async {
    try {
      if (isProfileImageChooseSuccess.value) {
        // Initialize Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            storage.ref().child('transation&profile_images/$fileName');

        // Upload image file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        // Get the image URL
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        profileImg.value = imageUrl;
      } else {
        Get.snackbar(
          'Image picking failed',
          'Sorry, the image is not picked!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();

    super.onClose();
  }
}
