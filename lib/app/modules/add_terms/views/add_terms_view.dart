import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_terms_controller.dart';

class AddTermsView extends GetView<AddTermsController> {
  const AddTermsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddTermsView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddTermsView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
