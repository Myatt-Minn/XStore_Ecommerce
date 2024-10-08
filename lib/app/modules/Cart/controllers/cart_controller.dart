import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xstore/app/data/cart_model.dart';

class CartController extends GetxController {
  // RxList of CartItem objects
  final storage = GetStorage();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.obs;
  final deliveryfees = 2000;

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage(); // Load cart items from storage
  }

  // Getter for cart item count
  int get itemCount => cartItems.length;

  // Add item to the cart
  void addItem(CartItem item) {
    cartItems.add(item);
    updateTotalAmount();
    saveCartToStorage();
  }

  // Increase quantity of an item
  void increaseQuantity(int index) {
    cartItems[index].quantity += 1;
    cartItems.refresh(); // Notify GetX that the list has changed
    updateTotalAmount();
  }

  // Decrease quantity of an item
  void decreaseQuantity(int index) {
    if (cartItems[index].quantity > 1) {
      cartItems[index].quantity -= 1;
      cartItems.refresh(); // Notify GetX that the list has changed
      updateTotalAmount();
    }
  }

  // Remove item from the cart
  void removeItem(int index) {
    cartItems.removeAt(index);
    updateTotalAmount();
    saveCartToStorage();
  }

  // Update the total amount
  void updateTotalAmount() {
    totalAmount.value = cartItems.fold<int>(0, (sum, item) {
      int itemTotal = (item.price * item.quantity);
      return sum + itemTotal;
    });
  }

  void saveCartToStorage() {
    List<Map<String, dynamic>> cartData = cartItems
        .map((item) =>
            item.toJson()) // Assuming you have a toJson method in CartItem
        .toList();
    storage.write('cart', cartData); // Save the cart to storage
  }

  void loadCartFromStorage() {
    List<dynamic> storedCart = storage.read<List<dynamic>>('cart') ?? [];
    cartItems.value = storedCart
        .map((item) =>
            CartItem.fromJson(item)) // Assuming you have a fromJson method
        .toList();
    updateTotalAmount();
  }

  int get finaltotalCost {
    return totalAmount.value + deliveryfees;
  }

  bool setOrder() {
    if (nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        addressController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  // Method to confirm the payment
  void confirmPayment() async {
    await createOrder(
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
      cartItems:
          Get.find<CartController>().cartItems, // Pass the observable list here
      totalPrice: finaltotalCost, // Example total price

      address: addressController.text,
      status: "Pending",
    );
    Get.toNamed('/order-success');
  }

  Future<void> createOrder({
    required List<CartItem> cartItems, // List of CartItem objects
    required int totalPrice,
    required String address,
    required String status,
    required String name,
    required String phoneNumber,
  }) async {
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

        "name": name,
        "phoneNumber": phoneNumber,
        "items": cartItems
            .map((item) => item.toJson())
            .toList(), // Convert CartItems to Maps

        "address": address,
      };

      // Add the order to Firestore
      await docRef.set(orderData);

      print("Order created successfully!");
    } catch (e) {
      Get.snackbar("Error", "Sorry, Error creating order");
    }
  }
}
