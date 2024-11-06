import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/privacy_policy_controller.dart';

class PrivacyPolicyView extends GetView<PrivacyPolicyController> {
  const PrivacyPolicyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
        centerTitle: true,
      ),
      body: FutureBuilder<String?>(
        future: controller.fetchTermsConditions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error loading Privacy Policy'));
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No Privacy Policy available.'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              snapshot.data!,
              style: const TextStyle(fontSize: 16.0),
            ),
          );
        },
      ),
    );
  }
}
