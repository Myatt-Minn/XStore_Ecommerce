import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Obx(() {
                return controller.isLoading.value
                    ? const LinearProgressIndicator()
                    : Container();
              }),
              const SizedBox(height: 25),
              // Logo
              Image.asset(ConstsConfig.logo, width: 100, height: 100),

              const SizedBox(height: 5),

              // Get Started Text
              const Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // Subtitle
              const Text(
                'Enter your information below',
                style: TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 132, 132, 132),
                ),
              ),

              const SizedBox(height: 30),

              // Form Container
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: const Color(0xFFB7DBBE), // Light green background
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    // Name TextField
                    // Name TextField with validation error message
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.nameError.isNotEmpty)
                              Text(controller.nameError.value,
                                  style: const TextStyle(color: Colors.red)),
                            TextField(
                              controller: controller.nameController,
                              decoration: InputDecoration(
                                labelText: 'Name',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 15),

                    // Name TextField with validation error message
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.emailError.isNotEmpty)
                              Text(controller.emailError.value,
                                  style: const TextStyle(color: Colors.red)),
                            TextField(
                              controller: controller.emailController,
                              decoration: InputDecoration(
                                labelText: 'Email',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 15),

                    // Password TextField with Obx to toggle visibility
                    // Name TextField with validation error message
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.passwordError.isNotEmpty)
                              Text(controller.passwordError.value,
                                  style: const TextStyle(color: Colors.red)),
                            TextField(
                              controller: controller.passwordController,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        )),

                    const SizedBox(height: 15),

                    // Name TextField with validation error message
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (controller.confirmPasswordError.isNotEmpty)
                              Text(controller.confirmPasswordError.value,
                                  style: const TextStyle(color: Colors.red)),
                            TextField(
                              controller: controller.confirmPasswordController,
                              decoration: InputDecoration(
                                labelText: 'Confirm Password',
                                prefixIcon: const Icon(Icons.person_outline),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ],
                        )),
                    const SizedBox(height: 20),

                    // Sign Up Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.signUp();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              ConstsConfig.secondarycolor, // Black button
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Sign up',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // Already have an account? Sign In
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account? ",
                          style:
                              TextStyle(color: Color.fromARGB(255, 48, 48, 48)),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed("/login");
                          },
                          child: const Text(
                            "Sign In",
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
