import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/auth_gate/controllers/auth_gate_controller.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthGateController controller = Get.find<AuthGateController>();
    return Scaffold(
        appBar: AppBar(
          title: const Text('No Internet Connection'),
          centerTitle: true,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/no_connection.jpg', height: 200),
              const SizedBox(height: 20),
              const Text(
                'You are not connected to the internet.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    controller.retryConnection();
                  },
                  child: Obx(() => (controller.isLoading.value)
                      ? const CircularProgressIndicator()
                      : const Text('Try Again'))),
            ],
          ),
        ));
  }
}
