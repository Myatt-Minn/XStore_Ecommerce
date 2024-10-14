import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/brand_list/controllers/brand_list_controller.dart';

class AddbrandView extends GetView<BrandListController> {
  const AddbrandView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add brand'),
        backgroundColor: const Color(0xFF95CCA9),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return controller.imageFile.value != null
                  ? Image.file(controller.imageFile.value!, height: 100)
                  : const SizedBox(height: 100);
            }),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => controller.pickImage(),
              child: const Text('Select Image'),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.titleController,
              decoration: InputDecoration(
                hintText: 'brand Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () => controller.addbrand(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF95CCA9),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text('Add brand'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
