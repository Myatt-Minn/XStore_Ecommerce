import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/cart_model.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

class PaymentController extends GetxController {
  // Rx variables for payment options
  var selectedPayment = ''.obs;
  var profileImg = "".obs;
  late File file;
  var isProfileImageChooseSuccess = false.obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    isProfileImageChooseSuccess.value = false;
  }

  // Method to select payment method
  void selectPayment(String method) {
    selectedPayment.value = method;
  }

  // Function to choose an image from File Picker
  Future<void> chooseImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      file = File(result.files.single.path!);
      isProfileImageChooseSuccess.value = true;
      await uploadImage(file);
    } else {
      // User canceled the picker
      Get.snackbar("Cancel", "No Image");
    }
  }

// Function to upload the selected image to Firebase Storage and save its metadata in Firestore
  Future<void> uploadImage(File imageFile) async {
    try {
      if (isProfileImageChooseSuccess.value) {
        isLoading.value = true;
        // Initialize Firebase Storage
        FirebaseStorage storage = FirebaseStorage.instance;
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        Reference storageRef =
            storage.ref().child('transation&profile_images/$fileName');

        // Upload image file to Firebase Storage
        UploadTask uploadTask = storageRef.putFile(imageFile);
        TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

        // Get the image URL
        String imageUrl = await taskSnapshot.ref.getDownloadURL();
        profileImg.value = imageUrl;
        isLoading.value = false;
      } else {
        Get.snackbar(
          'Image picking failed',
          'Sorry, the image is not picked!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  // Method to confirm the payment
  void confirmPayment() async {
    if (selectedPayment.isNotEmpty && profileImg.value != "") {
      // Perform necessary actions such as API calls
      // print("Payment confirmed with ${selectedPayment.value}");
      await createOrder(
          name: Get.arguments['name'],
          phoneNumber: Get.arguments['phoneNumber'],
          cartItems: Get.find<CartController>()
              .cartItems, // Pass the observable list here
          totalPrice: Get.arguments['totalCost'], // Example total price
          paymentMethod: selectedPayment.value,
          address: Get.arguments['address'],
          status: "Pending",
          transationUrl: profileImg.value);
      Get.toNamed('/order-success');
    } else {
      Get.snackbar(
          'Error', 'Please select a payment method and upload an image.');
    }
  }

  Future<void> createOrder(
      {required List<CartItem> cartItems, // List of CartItem objects
      required int totalPrice,
      required String paymentMethod,
      required String address,
      required String status,
      required String name,
      required String phoneNumber,
      required String transationUrl}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }
      final docRef = FirebaseFirestore.instance.collection('orders').doc();
      // Prepare the order data
      final orderData = {
        "userId": user.uid,
        "orderId": docRef.id,
        "orderDate": DateTime.now().toIso8601String(),
        "status": status, // Initial status
        "totalPrice": totalPrice,
        "transationUrl": transationUrl,
        "name": name,
        "phoneNumber": phoneNumber,
        "items": cartItems
            .map((item) => item.toJson())
            .toList(), // Convert CartItems to Maps
        "paymentMethod": paymentMethod,
        "address": address,
      };

      // Add the order to Firestore
      await docRef.set(orderData);

      print("Order created successfully!");
    } catch (e) {
      print("Error creating order: $e");
    }
  }
}
