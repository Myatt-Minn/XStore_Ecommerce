import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xstore/app/data/cart_model.dart';

class CartController extends GetxController {
  // RxList of CartItem objects
  final storage = GetStorage();
  var isLoading = false.obs;

  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage(); // Load cart items from storage
  }

  // Getter for cart item count
  int get itemCount => cartItems.length;

  // Add item to the cart
  void addItem(CartItem item) {
    // Check if the item already exists in the cart based on productId and size
    var existingItem = cartItems.firstWhereOrNull((element) =>
        element.productId == item.productId && element.size == item.size);

    if (existingItem != null) {
      // If the item exists, just increase the quantity
      existingItem.quantity += 1;
    } else {
      // Otherwise, add the item to the cart
      cartItems.add(item);
    }

    updateTotalAmount();
    saveCartToStorage();
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

  void clearCart() {
    cartItems.clear(); // Clear the in-memory cart items
    storage.remove('cart'); // Remove cart data from storage
    updateTotalAmount(); // Reset total amount
    update(); // Notify listeners
  }
}
