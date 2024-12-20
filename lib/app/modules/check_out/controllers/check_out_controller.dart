import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/cart_model.dart';
import 'package:xstore/app/data/order_model.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

class CheckOutController extends GetxController {
  //TODO: Implement CheckOutController

  var isLoading = false.obs;
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  // Observable properties
  var regions = <String>[].obs;
  var cities = <Map<String, dynamic>>[].obs;

  var selectedRegion = ''.obs;
  var selectedCity = ''.obs;

  var deliveryFee = 0.obs;
  @override
  void onInit() {
    super.onInit();

    fetchUserData();
    fetchRegions();
  }

  // Fetch regions from Firestore
  void fetchRegions() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('regions').get();

      regions.value =
          snapshot.docs.map((doc) => doc['name'] as String).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch regions.');
    }
  }

  // When a region is selected
  void onRegionSelected(String region) async {
    selectedRegion.value = region;
    selectedCity.value = ''; // Reset selected city
    deliveryFee.value = 0; // Reset delivery fee

    // Fetch cities for the selected region
    try {
      DocumentSnapshot regionDoc = await FirebaseFirestore.instance
          .collection('regions')
          .where('name', isEqualTo: region)
          .limit(1)
          .get()
          .then((snapshot) => snapshot.docs.first);

      cities.value = List<Map<String, dynamic>>.from(regionDoc['cities']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch cities.');
    }
  }

  // When a city is selected
  void onCitySelected(String city) {
    selectedCity.value = city;

    // Update delivery fee based on selected city
    var cityData =
        cities.firstWhere((c) => c['name'] == city, orElse: () => {});
    if (cityData.isNotEmpty) {
      deliveryFee.value = cityData['deliveryFee'];
    } else {
      Get.snackbar("GG", "G");
    }
  }

  int get finaltotalcost {
    return Get.find<CartController>().totalAmount.value + deliveryFee.value;
  }

  bool setOrder() {
    if (nameController.text.isNotEmpty &&
        phoneNumberController.text.isNotEmpty &&
        addressController.text.isNotEmpty &&
        deliveryFee.value != 0) {
      return true;
    } else {
      return false;
    }
  }

// Method to confirm the payment
  void confirmPayment() async {
    isLoading.value = true;

    // Perform stock check for all items in the cart before placing the order
    bool isStockAvailable = await checkStockForOrder(
      Get.find<CartController>()
          .cartItems, // Pass the observable cartItems list here
    );

    if (!isStockAvailable) {
      Get.snackbar(
          'Stock Error', 'Not enough stock for one or more items in your cart.',
          backgroundColor: Colors.red);
      isLoading.value = false;
      return; // Exit the function if stock is insufficient
    }

    // Proceed with order creation if stock is sufficient
    await createOrder(
      name: nameController.text,
      phoneNumber: phoneNumberController.text,
      cartItems: Get.find<CartController>().cartItems,
      totalPrice: finaltotalcost,
      address: addressController.text,
      status: "Pending",
    );

    Get.offNamed('/order-success');
    isLoading.value = false;
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
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("User not logged in");
      }

      final docRef = FirebaseFirestore.instance.collection('orders').doc();

      // Create the OrderModel instance
      Timestamp timestamp =
          Timestamp.now(); // Assuming 'orderDate' is a Timestamp field
      DateTime dateTime = timestamp.toDate();

      final order = OrderItem(
          userId: user.uid,
          orderId: docRef.id,
          orderDate: dateTime,
          status: status, // Initial status
          totalPrice: totalPrice,
          paymentMethod: "COD", // Assuming COD for now
          name: name,
          phoneNumber: phoneNumber,
          address: address,
          items: cartItems, // Convert CartItems to Maps
          deliveryFee: deliveryFee.value);

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
    } catch (e) {
      Get.snackbar("Error", "Sorry, Error creating order: $e");
    }
  }

  // Fetch current user data from Firestore
  void fetchUserData() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists) {
        nameController.text = userDoc['name'] ?? '';
        phoneNumberController.text =
            userDoc['phoneNumber'] ?? ''; // Fetch phone number
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load user data.');
    }
  }
}
