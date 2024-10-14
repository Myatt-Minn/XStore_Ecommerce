import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/order_model.dart';

class OrderListController extends GetxController {
  //TODO: Implement OrderListController

  var isLoading = false.obs;
  var orderList = <OrderItem>[].obs;
  var filteredList = <OrderItem>[].obs; // To hold filtered orders

  var searchQuery = ''.obs; // To hold the search query

  @override
  void onInit() {
    super.onInit();
    fetchOrders();
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('orders').get();

      // Map Firestore data to the Product model with null checks and detailed logging
      orderList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return OrderItem.fromMap(data);
      }).toList();
      filteredList.assignAll(orderList);
      isLoading.value = false;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar('Error', 'Failed to fetch products');
      isLoading.value = false;
    }
  }

  Future<void> deleteorder(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      fetchOrders();

      Get.snackbar('Success', 'order deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete order: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }

  void searchOrders(String query) {
    searchQuery.value = query; // Update the search query

    // If the query is empty, show all orders
    if (query.isEmpty) {
      filteredList.assignAll(orderList);
    } else {
      // Filter the order list based on the search query
      filteredList.assignAll(orderList.where((order) {
        return order.name!.toLowerCase().contains(query.toLowerCase()) ||
            order.paymentMethod!.toLowerCase().contains(query.toLowerCase()) ||
            order.phoneNumber!
                .contains(query) || // Assuming phone number is a string
            order.status!.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }
}
