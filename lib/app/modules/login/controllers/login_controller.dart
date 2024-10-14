import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginController extends GetxController {
  // Controllers for TextFields
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Reactive variables
  var isPasswordHidden = true.obs; // To toggle password visibility
  var isLoading = false.obs; // To show a loading indicator
  var emailError = ''.obs; // Validation error for email
  var passwordError = ''.obs; // Validation error for password
  var generalError = ''.obs; // General error message for login failure

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login function
  Future<void> loginUser() async {
    // Clear any previous error messages
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';

    // Validate input
    if (!validateInput()) {
      return;
    }

    // Start loading
    isLoading.value = true;

    try {
      // Attempt to sign in with email and password
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      // Handle login errors
      if (e.code == 'user-not-found') {
        generalError.value = 'No user found with this email.';
      } else if (e.code == 'wrong-password') {
        generalError.value = 'Incorrect password.';
      } else {
        generalError.value = 'User not Signed Up/Incorrect Password';
      }
    } catch (e) {
      generalError.value = 'An unexpected error occurred. Please try again.';
    } finally {
      // Stop loading
      isLoading.value = false;
    }
  }

  // Input validation function
  bool validateInput() {
    bool isValid = true;

    // Email validation
    if (emailController.text.trim().isEmpty) {
      emailError.value = 'Please enter your email.';
      isValid = false;
    } else if (!GetUtils.isEmail(emailController.text.trim())) {
      emailError.value = 'Please enter a valid email address.';
      isValid = false;
    }

    // Password validation
    if (passwordController.text.trim().isEmpty) {
      passwordError.value = 'Please enter your password.';
      isValid = false;
    } else if (passwordController.text.trim().length < 6) {
      passwordError.value = 'Password must be at least 6 characters long.';
      isValid = false;
    }

    return isValid;
  }

  // Clear error messages on text change
  void clearErrorMessages() {
    emailError.value = '';
    passwordError.value = '';
    generalError.value = '';
  }

  // Dispose controllers when not needed
  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
