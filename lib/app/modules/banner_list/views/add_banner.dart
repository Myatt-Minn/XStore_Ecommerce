import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/banner_list/controllers/banner_list_controller.dart';

class AddbannerView extends GetView<BannerListController> {
  const AddbannerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add banner',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: ConstsConfig.primarycolor,
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
            Center(
              child: ElevatedButton(
                onPressed: () => controller.pickImage(),
                child: const Text('Select Image'),
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                onPressed: () => controller.addbanner(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ConstsConfig.secondarycolor,
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Add banner',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
