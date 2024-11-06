import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/data/user_model.dart';

class CustomerListController extends GetxController {
  //TODO: Implement CustomerListController

  var isLoading = false.obs;
  var userList = <UserModel>[].obs;
  var filteredList = <UserModel>[].obs; // To hold filtered users

  var searchQuery = ''.obs; // To hold the search query

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('users').get();

      // Map Firestore data to the Product model with null checks and detailed logging
      userList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return UserModel.fromJson(data);
      }).toList();
      filteredList.assignAll(userList);
      isLoading.value = false;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar('Error', 'Failed to fetch products');
      isLoading.value = false;
    }
  }

  void searchUsers(String query) {
    searchQuery.value = query; // Update the search query

    // If the query is empty, show all users
    if (query.isEmpty) {
      filteredList.assignAll(userList);
    } else {
      // Filter the user list based on the search query
      filteredList.assignAll(userList.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
            user.email.toLowerCase().contains(query.toLowerCase()) ||
            user.role.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

  Future<void> deletecustomer(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(orderId)
          .delete();
      fetchUsers();

      Get.snackbar('Success', 'user deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ConstsConfig.primarycolor,
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete user: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }
}
