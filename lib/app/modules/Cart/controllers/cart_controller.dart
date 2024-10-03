import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:xstore/app/data/cart_model.dart';

class CartController extends GetxController {
  // RxList of CartItem objects
  final storage = GetStorage();

  var cartItems = <CartItem>[].obs;
  var totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCartFromStorage(); // Load cart items from storage
  }

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
    totalAmount.value = cartItems.fold<double>(0.0, (sum, item) {
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
}
