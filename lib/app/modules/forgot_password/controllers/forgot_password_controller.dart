import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  var email = ''.obs;
  var newPassword = ''.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Send Password Reset Email
  void sendPasswordResetEmail() async {
    try {
      await _auth.sendPasswordResetEmail(email: email.value);

      Get.snackbar(
        'Success',
        'Password reset email sent. Please check your email',
        backgroundColor: const Color(0xFF8E2DE2),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
          'Error', 'Failed to send password reset email. Please try again');
    }
  }
}
