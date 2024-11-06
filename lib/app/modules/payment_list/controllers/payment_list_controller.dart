import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/data/payment_model.dart';

class PaymentListController extends GetxController {
  //TODO: Implement PaymentListController

  var isLoading = false.obs;
  var paymentList = <PaymentModel>[].obs;

  var titleController = TextEditingController();
  var imgUrlController = TextEditingController();
  var phoneNumberController = TextEditingController();
  var nameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  var imageFile = Rx<File?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
    }
  }

  Future<void> addpayment() async {
    if (imageFile.value != null &&
        titleController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        nameController.text.isNotEmpty) {
      try {
        isLoading.value = true;
        // Upload image to Firebase Storage
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            FirebaseStorage.instance.ref().child('payments/$fileName');

        UploadTask uploadTask = storageRef.putFile(imageFile.value!);
        TaskSnapshot snapshot = await uploadTask;

        // Get download URL
        String downloadUrl = await snapshot.ref.getDownloadURL();
        final docRef = FirebaseFirestore.instance.collection('payments').doc();
        // Save payment to Firestore
        await docRef.set({
          'id': docRef.id,
          'title': titleController.text,
          'imgUrl': downloadUrl,
          'phone': phoneNumberController.text,
          'name': nameController.text
        });

        Get.snackbar('Success', 'payment added successfully!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: ConstsConfig.primarycolor,
            colorText: Colors.black);
        isLoading.value = false;
        // Clear input fields
        titleController.clear();
        imageFile.value = null;
        fetchPayments();
      } catch (e) {
        Get.snackbar('Error', 'Failed to add payment: $e',
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

  Future<void> fetchPayments() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('payments').get();

      // Map Firestore data to the Product model with null checks and detailed logging
      paymentList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return PaymentModel.fromJson(data);
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

  Future<void> deletepayment(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('payments')
          .doc(orderId)
          .delete();
      fetchPayments();

      Get.snackbar('Success', 'payment deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ConstsConfig.primarycolor,
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete payment: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }
}
