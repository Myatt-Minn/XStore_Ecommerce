import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/cart_model.dart';
import 'package:xstore/app/data/product_model.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

class ProductDetailsController extends GetxController {
  late Product product;

  var selectedSize = 0.obs;
  var selectedColor = 0.obs;
  var quantity = 1.obs;
  var selectedImageIndex = 0.obs; // Index for the currently selected main image

  @override
  void onInit() {
    super.onInit();
    // Get the product passed from the Product List
    product = Get.arguments as Product;
  }

  void changeSize(int index) {
    selectedSize.value = index;
  }

  void changeColor(int index) {
    selectedColor.value = index;
  }

  void increaseQuantity() {
    quantity.value++;
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

  void addToCart() {
    // Create a CartItem using the current product, selected size, color, and quantity
    CartItem cartItem = CartItem(
      productId: product.id!,
      name: product.name!,
      price: product.price!,
      imageUrl: product.images![selectedImageIndex.value],
      size: product.sizes![selectedSize.value],
      color: product.colors![selectedColor.value],
      quantity: quantity.value,
    );

    // Get an instance of the CartController and add the item to the cart
    Get.find<CartController>().addItem(cartItem);
    Get.snackbar('Success', '${product.name} added to cart successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF95CCA9),
        colorText: Colors.black);
  }
}
