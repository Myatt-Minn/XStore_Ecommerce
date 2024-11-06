import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/cart_model.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/data/product_model.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  var product = Product().obs;

  var selectedSize = 0.obs;

  var quantity = 1.obs;
  var selectedImageIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the product passed from the Product List
    product.value = Get.arguments as Product;
  }

  void changeSize(int index) {
    selectedSize.value = index;
  }

  // Function to increase quantity
  void increaseQuantity() {
    if (selectedSize.value != 0) {
      var selectedSizeData = product.value.sizes!
          .firstWhere((sizeData) => sizeData['size'] == selectedSize.value);

      int availableStock = selectedSizeData['quantity'];

      // Allow increasing only if less than available stock
      if (quantity.value < availableStock) {
        quantity.value++;
      } else {
        Get.snackbar(
            "Stock Limit", "You have reached the maximum available stock.",
            backgroundColor: Colors.red, colorText: Colors.black);
      }
    }
  }

  void decreaseQuantity() {
    if (quantity.value > 1) {
      quantity.value--;
    }
  }

  void changeImage(int index) {
    selectedImageIndex.value =
        index; // Change the main image based on selected thumbnail
  }

// Function to select size
  void selectSize(int size) {
    selectedSize.value = size;
    quantity.value = 1; // Reset quantity when a new size is selected
  }

  void addToCart() {
    final selectedSizeValue = selectedSize.value;

    if (selectedSizeValue != 0) {
      // Find the selected size's price and quantity
      var selectedSizeData = product.value.sizes!
          .firstWhere((sizeData) => sizeData['size'] == selectedSizeValue);

      int price = selectedSizeData['price'];
      int stock = selectedSizeData['quantity'];

      // Get an instance of the CartController
      final cartController = Get.find<CartController>();

      // Calculate total quantity of the same product and size already in the cart
      int totalInCart = cartController.cartItems
          .where((item) =>
              item.productId == product.value.id! &&
              item.size == selectedSizeValue)
          .fold(0, (sum, item) => sum + item.quantity);

      // Check if adding the new quantity would exceed stock
      if (totalInCart + quantity.value > stock) {
        Get.snackbar(
          "Stock Limit Exceeded",
          "You can only add ${stock - totalInCart} more of this item to the cart.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        // Create a CartItem using the current product, selected size, color, and quantity
        CartItem cartItem = CartItem(
          productId: product.value.id!,
          name: product.value.name!,
          price: price,
          imageUrl: product.value.images![0],
          size: selectedSize.value,
          quantity: quantity.value,
        );

        // Add the item to the cart
        cartController.addItem(cartItem);

        Get.snackbar(
          'Success',
          '${product.value.name} added to cart successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: ConstsConfig.primarycolor,
          colorText: Colors.black,
        );
      }
    } else {
      Get.snackbar("Error", "Please select a size.");
    }
  }
}
