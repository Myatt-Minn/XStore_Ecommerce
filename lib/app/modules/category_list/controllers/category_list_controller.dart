import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstore/app/data/category_model.dart';

class CategoryListController extends GetxController {
  //TODO: Implement CategoryListController

  var isLoading = false.obs;
  var titleController = TextEditingController();
  var imgUrlController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var categoryList = <CategoryModel>[].obs;

  var imageFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> addCategory() async {
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
        final docRef =
            FirebaseFirestore.instance.collection('categories').doc();
        // Save category to Firestore
        await docRef.set({
          'id': docRef.id,
          'title': titleController.text,
          'imgUrl': downloadUrl,
        });

        Get.snackbar('Success', 'Category added successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green[100],
            colorText: Colors.black);
        isLoading.value = false;
        // Clear input fields
        titleController.clear();
        imageFile.value = null;
        fetchCategories();
      } catch (e) {
        Get.snackbar('Error', 'Failed to add category: $e',
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

  Future<void> fetchCategories() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();

      // Map Firestore data to the Product model with null checks and detailed logging
      categoryList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return CategoryModel.fromJson(data);
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

  Future<void> deletecategory(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('categories')
          .doc(orderId)
          .delete();
      fetchCategories();

      Get.snackbar('Success', 'category deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete category: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    imgUrlController.dispose();
    super.onClose();
  }
}
