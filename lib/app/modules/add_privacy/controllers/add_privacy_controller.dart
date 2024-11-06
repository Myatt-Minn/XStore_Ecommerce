import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

class AddPrivacyController extends GetxController {
  //TODO: Implement AddPrivacyController
  final TextEditingController privacyPolicyController = TextEditingController();
  final TextEditingController termsController = TextEditingController();
  RxBool isUpdateMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPolicies();
  }

  // Function to load existing policies from Firestore
  Future<void> loadPolicies() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('legal')
          .doc('policies')
          .get();

      if (doc.exists) {
        // If the document exists, populate the TextFields with the existing data
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        privacyPolicyController.text = data['privacyPolicy'] ?? '';
        termsController.text = data['termsAndConditions'] ?? '';

        isUpdateMode.value = true; // Set mode to update
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load policies: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }

  // Function to create or update policies in Firestore
  Future<void> savePolicies() async {
    String privacyPolicy = privacyPolicyController.text.trim();
    String termsAndConditions = termsController.text.trim();

    if (privacyPolicy.isEmpty || termsAndConditions.isEmpty) {
      Get.snackbar('Error', 'Please fill in both fields before saving.',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('legal').doc('policies').set({
        'privacyPolicy': privacyPolicy,
        'termsAndConditions': termsAndConditions,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      Get.snackbar('Success', 'Policies saved successfully.',
          backgroundColor: ConstsConfig.primarycolor, colorText: Colors.white);

      isUpdateMode.value = true; // After saving, switch to update mode
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload policies: $e',
          backgroundColor: Colors.redAccent, colorText: Colors.white);
    }
  }
}
