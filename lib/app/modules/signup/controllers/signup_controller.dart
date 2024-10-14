import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  //TODO: Implement SignupController

  var isPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  var isLoading = false.obs;

  // Controllers for input fields
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Reactive variables for validation error messages
  var nameError = ''.obs;
  var emailError = ''.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;

  // Firebase authentication and Firestore instance
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Toggles for password visibility
  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  // Validation function
  bool validate() {
    bool isValid = true;

    // Name validation
    if (nameController.text.isEmpty) {
      nameError.value = 'Name is required';
      isValid = false;
    } else {
      nameError.value = '';
    }

    // Email validation
    if (!GetUtils.isEmail(emailController.text)) {
      emailError.value = 'Please enter a valid email';
      isValid = false;
    } else {
      emailError.value = '';
    }

    // Password validation
    if (passwordController.text.length < 6) {
      passwordError.value = 'Password must be at least 6 characters long';
      isValid = false;
    } else {
      passwordError.value = '';
    }

    // Confirm password validation
    if (confirmPasswordController.text != passwordController.text) {
      confirmPasswordError.value = 'Passwords do not match';
      isValid = false;
    } else {
      confirmPasswordError.value = '';
    }

    return isValid;
  }

  // Sign up function
  Future<void> signUp() async {
    if (!validate()) return; // Do not proceed if validation fails

    try {
      isLoading.value = true;
      // Firebase Auth sign up
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // Save user info to Firestore
      await firestore.collection('users').doc(uid).set({
        'uid': uid,
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'profilepic': "", // Default profile picture URL
        "role": "user",
        "phoneNumber": "",
      });
      isLoading.value = false;
      // Show success message
      Get.snackbar('Success', 'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFF95CCA9),
          colorText: Colors.white);
    } catch (e) {
      // Handle sign up error
      Get.snackbar('Error', e.toString(), snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Upload default profile pic to Firebase Storage
  Future<String> uploadDefaultProfilePic(String uid) async {
    try {
      // Default profile picture path (adjust the path as needed)
      File defaultProfilePic = File('assets/images/default_profile.png');

      // Firebase Storage reference
      Reference storageRef =
          FirebaseStorage.instance.ref().child('profilepics/$uid.png');

      // Upload the file
      UploadTask uploadTask = storageRef.putFile(defaultProfilePic);
      TaskSnapshot snapshot = await uploadTask;

      // Get download URL of uploaded file
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading profile picture: $e');
      return ''; // Return empty string in case of error
    }
  }
}
