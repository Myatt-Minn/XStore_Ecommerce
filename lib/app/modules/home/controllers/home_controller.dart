import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<Product> productList = <Product>[].obs;
  RxList<Product> popularProducts = <Product>[].obs;
  late PageController pageController;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List to store banner URLs
  var banners = <String>[].obs;

  var currentBanner = 0.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBanners();
    startAutoSlide();
    pageController = PageController(initialPage: currentBanner.value);
    fetchProducts();
    fetchPopular();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;

      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('new_arrivals').get();

      // Map Firestore data to the Product model with null checks and detailed logging
      productList.value = snapshot.docs.map((doc) {
        // Check if the document data is null
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return Product.fromJson(data);
      }).toList();

      isLoading.value = false;
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar('Error', 'Failed to fetch products');
    }
  }

  Future<void> fetchPopular() async {
    try {
      // Reference to your Firestore collection
      isLoading.value = true;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('new_arrivals').get();

      // Map Firestore data to the Product model
      popularProducts.value = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<dynamic, dynamic>);
      }).toList();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    }
  }

// Function to change the current page
  void changePage(int value) {
    currentBanner.value = value;
  }

  // Fetch banner URLs from Firestore
  void fetchBanners() async {
    try {
      QuerySnapshot snapshot = await firestore.collection('banners').get();
      banners.value =
          snapshot.docs.map((doc) => doc['imgUrl'].toString()).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load banners');
    }
  }

  void startAutoSlide() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (currentBanner.value < banners.length - 1) {
        currentBanner.value++;
      } else {
        currentBanner.value = 0; // Loop back to the first banner
      }

      pageController.animateToPage(
        currentBanner.value,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void onClose() {
    super.onClose();
    pageController.dispose();
  }
}
