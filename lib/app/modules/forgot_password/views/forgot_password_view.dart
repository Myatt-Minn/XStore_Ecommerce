import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends GetView<ForgotPasswordController> {
  const ForgotPasswordView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recovery Password")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('images/forgot_password.png', height: 200),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Enter Your Email Address",
                    prefixIcon: Icon(Icons.email),
                  ),
                  onChanged: (value) => controller.email.value = value,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: controller.sendPasswordResetEmail,
                  child: const Text("Send Password Reset Email"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
