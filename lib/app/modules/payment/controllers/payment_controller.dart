import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/cart_model.dart';
import 'package:xstore/app/data/order_model.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

class PaymentController extends GetxController {
  // Rx variables for payment options

  var transitionImage = "".obs;
  late File file;
  var isProfileImageChooseSuccess = false.obs;
  var isLoading = false.obs;
  var isOrder = false.obs;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  var payments = <Map<String, dynamic>>[].obs; // List to store payment data
  var selectedPayment = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPayments(); // Fetch payment data when the controller initializes
    isProfileImageChooseSuccess.value = false;
  }

  // Fetch payment data from Firestore
  void fetchPayments() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('payments').get();
      payments.value = snapshot.docs
          .map((doc) => {
                'name': doc['name'],
                'title': doc['title'],
                'imgUrl': doc['imgUrl'],
                'phone':
                    doc['phone'], // Assuming each document has a 'phone' field
              })
          .toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load payment options');
    }
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
        transitionImage.value = imageUrl;
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

  void confirmPayment() async {
    // Validate if a payment method is selected
    if (selectedPayment.value.isEmpty) {
      Get.snackbar('Payment Error', 'Please select a payment method.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    // Validate if an image has been uploaded
    if (transitionImage.value.isEmpty) {
      Get.snackbar('Image Error', 'Please upload a transaction screenshot.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isOrder.value = true;

    // Perform stock check for all items in the cart before placing the order
    bool isStockAvailable = await checkStockForOrder(
      Get.find<CartController>().cartItems,
    );

    if (!isStockAvailable) {
      Get.snackbar(
          'Stock Error', 'Not enough stock for one or more items in your cart.',
          backgroundColor: Colors.red);
      isOrder.value = false;
      return;
    }

    // Proceed with order creation if stock is sufficient
    await createOrder(
      name: Get.arguments['name'],
      phoneNumber: Get.arguments['phoneNumber'],
      cartItems: Get.find<CartController>().cartItems,
      totalPrice: Get.arguments['totalCost'],
      address: Get.arguments['address'],
      status: "Pending",
      deliveryFee: Get.arguments['deliveryFee'],
    );

    Get.offNamed('/order-success');
    isOrder.value = false;
  }

// Function to check if there's enough stock for each item in the cart
  Future<bool> checkStockForOrder(List<CartItem> cartItems) async {
    for (var cartItem in cartItems) {
      // Fetch the latest stock from Firestore for the specific product and size
      var productDoc = await FirebaseFirestore.instance
          .collection('new_arrivals')
          .doc(cartItem.productId)
          .get();

      if (!productDoc.exists) {
        Get.snackbar('Stock Error', 'Product not found.');
        return false; // Exit if product doesn't exist
      }

      var productData = productDoc.data();
      var sizeData = productData!['sizes'].firstWhere(
          (size) => size['size'] == cartItem.size,
          orElse: () => null);

      if (sizeData == null) {
        Get.snackbar(
            'Stock Error', 'Size not found for product ${cartItem.name}.');
        return false; // Exit if size doesn't exist
      }

      int availableStock = sizeData['quantity'];

      // Check if the quantity in the cart exceeds the available stock
      if (cartItem.quantity > availableStock) {
        Get.snackbar('Stock Error',
            'Not enough stock for ${cartItem.name}, size: ${cartItem.size}.',
            backgroundColor: Colors.red);
        return false; // Exit if stock is insufficient
      }
    }

    return true; // Return true if stock is sufficient for all items
  }

  Future<void> createOrder({
    required List<CartItem> cartItems, // List of CartItem objects
    required int totalPrice,
    required String address,
    required String status,
    required String name,
    required String phoneNumber,
    required int deliveryFee,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final docRef = FirebaseFirestore.instance.collection('orders').doc();
      Timestamp timestamp =
          Timestamp.now(); // Assuming 'orderDate' is a Timestamp field
      DateTime dateTime = timestamp.toDate();

      // Create the OrderModel instance
      final order = OrderItem(
          userId: user.uid,
          orderId: docRef.id,
          orderDate: dateTime,
          status: status, // Initial status
          totalPrice: totalPrice,
          paymentMethod: selectedPayment.value,
          transationUrl: transitionImage.value,
          name: name,
          phoneNumber: phoneNumber,
          address: address,
          items: cartItems, // Convert CartItems to Maps
          deliveryFee: deliveryFee);

      // Add the order to Firestore
      await docRef.set(order.toMap());

      // Update stock for each product and size
      for (var cartItem in cartItems) {
        // Get product document from Firestore
        var productDoc = await FirebaseFirestore.instance
            .collection('new_arrivals')
            .doc(cartItem.productId)
            .get();

        if (productDoc.exists) {
          var productData = productDoc.data();
          var sizes = productData!['sizes'];

          // Find the correct size and reduce its quantity
          var updatedSizes = sizes.map((sizeData) {
            if (sizeData['size'] == cartItem.size) {
              int updatedQuantity = sizeData['quantity'] - cartItem.quantity;
              return {
                ...sizeData,
                'quantity': updatedQuantity < 0
                    ? 0
                    : updatedQuantity, // Prevent negative stock
              };
            } else {
              return sizeData;
            }
          }).toList();

          // Update the product document with the new size quantities
          await FirebaseFirestore.instance
              .collection('new_arrivals')
              .doc(cartItem.productId)
              .update({
            'sizes': updatedSizes,
          });
        }
      }

      print("Order created, stock updated, and cart cleared successfully!");
    } catch (e) {
      Get.snackbar("Error", "Sorry, Error creating order: $e");
    }
  }
}
