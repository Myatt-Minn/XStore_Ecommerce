import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/data/order_model.dart';

class OrderHistoryController extends GetxController {
  //TODO: Implement OrderHistoryController

  var orderList = <OrderItem>[].obs; // Reactive list to store orders
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory(); // Fetch data when the controller is initialized
  }

  Future<void> fetchOrderHistory() async {
    try {
      isLoading(true); // Set loading to true

      // Get the current user's ID
      String userId = FirebaseAuth.instance.currentUser!.uid;

      // Query Firestore to get orders for the current user, ordered by 'orderDate' in descending order
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('orders')
          .where('userId', isEqualTo: userId) // Filter by userId
          .orderBy('orderDate', descending: true) // Order by 'orderDate'
          .get();

      // Map Firestore documents to OrderItem model using the fromMap method
      var orders = querySnapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return OrderItem.fromMap(data); // Use the fromMap function here
      }).toList();

      orderList.assignAll(orders); // Update reactive order list
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading(false); // Set loading to false
    }
  }

  String formatDate(String dateString) {
    // Parse the date string into a DateTime object
    DateTime parsedDate = DateTime.parse(dateString);

    // Format the date to "yyyy-MM-dd" format or any other format you want
    String formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);

    return formattedDate;
  }

  // Function to delete an order
  Future<void> deleteOrder(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(orderId)
          .delete();
      fetchOrderHistory();

      Get.snackbar('Success', 'Order deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ConstsConfig.primarycolor,
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete order: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }
}
