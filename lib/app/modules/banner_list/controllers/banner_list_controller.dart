import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstore/app/data/banner_model.dart';

class BannerListController extends GetxController {
  //TODO: Implement BannerListController

  var isLoading = false.obs;
  var bannerList = <BannerModel>[].obs;
  var imgUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var imageFile = Rx<File?>(null);

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> addbanner() async {
    if (imageFile.value != null) {
      try {
        isLoading.value = true;
        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('banners/$fileName');

        UploadTask uploadTask = storageRef.putFile(imageFile.value!);
        TaskSnapshot snapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        final docRef = FirebaseFirestore.instance.collection('banners').doc();
        // Save banner to Firestore
        await docRef.set({
          'id': docRef.id,
          'imgUrl': downloadUrl,
        });

        Get.snackbar('Success', 'banner added successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.black);
        isLoading.value = false;
        // Clear input fields

        imageFile.value = null;
        fetchBanners();
      } catch (e) {
        Get.snackbar('Error', 'Failed to add banner: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.black);
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Warning', 'Please select an image and fill all the fields.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellow[100],
          colorText: Colors.black);
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
  }

  Future<void> fetchBanners() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('banners').get();

      // Map Firestore data to the Banner model with null checks and detailed logging
      bannerList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return BannerModel.fromJson(data);
      }).toList();

      isLoading.value = false;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar('Error', 'Failed to fetch products');
      isLoading.value = false;
    }
  }

  Future<void> deleteBanner(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('banners')
          .doc(orderId)
          .delete();
      fetchBanners();

      Get.snackbar('Success', 'Banner deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete banner: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }
}
