import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/account/controllers/account_controller.dart';

class EditProfileController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  // Reactive variables for the profile fields
  var fullName = ''.obs;
  var phoneNumber = ''.obs;

  var isLoading = false.obs;
  var isProfileImageChooseSuccess = false.obs;
  var profileImg = "".obs;

  late File file;
  // Text controllers for the TextFields
  late TextEditingController fullNameController;
  late TextEditingController phoneController;

  // Show error message if validation fails
  var showError = false.obs;
  @override
  void onReady() {
    super.onReady();
    isProfileImageChooseSuccess.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    phoneController = TextEditingController();

    fetchUserData(); // Fetch user data when the controller initializes
  }

  // Fetch current user data from Firestore
  void fetchUserData() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        fullName.value = userDoc['name'] ?? '';
        phoneNumber.value = userDoc['phoneNumber'] ?? ''; // Fetch phone number
        profileImg.value = userDoc['profilepic'] ?? '';

        // Set values in TextControllers for initial state
        fullNameController.text = fullName.value;
        phoneController.text = phoneNumber.value; // Set phone number
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data.');
    }
  }

  // Validate fields
  bool validateFields() {
    return fullNameController.text.isNotEmpty &&
        phoneController.text.isNotEmpty;
  }

  // Check if a field is empty
  bool isEmpty(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  // Update user profile data in Firestore
  void updateUserProfile() async {
    if (!validateFields()) {
      showError.value = true;
      return;
    }

    try {
      isLoading.value = true;
      await uploadImage(file);
      await _firestore.collection('users').doc(userId).set({
        'name': fullNameController.text,
        'phoneNumber': phoneController.text, // Add phone number
        'profilepic': profileImg.value,
      }, SetOptions(merge: true)); // Merge to avoid overwriting
      Get.find<AccountController>().fetchProfilePic();
      Get.snackbar('Success', 'Profile updated successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);

      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update profile.');
      isLoading.value = false;
    }
  }

  // Function to choose an image from File Picker
  Future<void> chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      file = File(result.files.single.path!);
      isProfileImageChooseSuccess.value = true;
    } else {
      Get.snackbar("Cancel", "No Image");
    }
  }

  Future<void> uploadImage(File imageFile) async {
    try {
      if (isProfileImageChooseSuccess.value) {
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef = storage.ref().child('profile_images/$fileName');

        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        profileImg.value = imageUrl;
      } else {
        Get.snackbar('Image picking failed', 'Sorry, the image is not picked!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
