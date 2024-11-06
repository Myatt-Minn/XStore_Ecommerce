import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/full_screen_image_controller.dart';

class FullScreenImageView extends GetView<FullScreenImageController> {
  const FullScreenImageView({super.key});
  @override
  Widget build(BuildContext context) {
    var imageUrl = Get.arguments;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          child: Image.network(imageUrl),
        ),
      ),
    );
  }
}
