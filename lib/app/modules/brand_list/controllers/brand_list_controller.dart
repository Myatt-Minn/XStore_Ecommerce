import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstore/app/data/brand_model.dart';

class BrandListController extends GetxController {
  //TODO: Implement BrandListController

  var isLoading = false.obs;
  var brandList = <BrandModel>[].obs;
  var titleController = TextEditingController();
  var imgUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var imageFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchBrands();
  }

  Future<void> fetchBrands() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('brand').get();

      // Map Firestore data to the brand model with null checks and detailed logging
      brandList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return BrandModel.fromJson(data);
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

  Future<void> deletebrand(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('brand')
          .doc(orderId)
          .delete();
      fetchBrands();

      Get.snackbar('Success', 'brand deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete brand: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> addbrand() async {
    if (imageFile.value != null && titleController.text.isNotEmpty) {
      try {
        isLoading.value = true;
        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('categories/$fileName');

        UploadTask uploadTask = storageRef.putFile(imageFile.value!);
        TaskSnapshot snapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        final docRef = FirebaseFirestore.instance.collection('brand').doc();
        // Save brand to Firestore
        await docRef.set({
          'id': docRef.id,
          'title': titleController.text,
          'imgUrl': downloadUrl,
        });

        Get.snackbar('Success', 'brand added successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.black);
        isLoading.value = false;
        // Clear input fields
        titleController.clear();
        imageFile.value = null;
        fetchBrands();
      } catch (e) {
        Get.snackbar('Error', 'Failed to add brand: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red[100],
            colorText: Colors.black);
        isLoading.value = false;
      }
    } else {
      Get.snackbar('Warning', 'Please select an image and enter a title.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.yellow[100],
          colorText: Colors.black);
      isLoading.value = false;
    }
  }
}
