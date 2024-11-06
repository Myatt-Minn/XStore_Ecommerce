import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/add_privacy_controller.dart';

class AddPrivacyView extends GetView<AddPrivacyController> {
  const AddPrivacyView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin: Privacy Policy & Terms'),
        backgroundColor: ConstsConfig.primarycolor,
      ),
      body: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: MediaQuery.of(context).size.height -
                AppBar().preferredSize.height,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Privacy Policy',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: controller.privacyPolicyController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter privacy policy...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Terms and Conditions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: controller.termsController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Enter terms and conditions...',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.savePolicies,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ConstsConfig.secondarycolor,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Obx(
                      () => Text(
                        controller.isUpdateMode.value
                            ? 'Update Policies'
                            : 'Save Policies',
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
