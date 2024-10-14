import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/order_model.dart';

class AdminDashboardController extends GetxController {
  //TODO: Implement AdminDashboardController

  var username = ''.obs;
  var email = ''.obs;
  var userCount = 0.obs;
  var productCount = 0.obs;
  var orderCount = 0.obs;
  var categoryCount = 0.obs;
  var bannerCount = 0.obs;
  var paymentCount = 0.obs;
  var brandCount = 0.obs;

  // List to hold recent order data
  var recentOrders = <OrderItem>[].obs;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchProfilePic();
    fetchDashboardData();
  }

  // Function to retrieve the profile picture from Firestore
  Future<void> fetchProfilePic() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (userDoc.exists && userDoc.data() != null) {
        username.value = userDoc['name'];
        email.value = userDoc['email'];
      } else {
        Get.snackbar('Error', 'User document does not exist.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to retrieve profile picture.');
    }
  }

  // Fetch dashboard data from Firestore
  Future<void> fetchDashboardData() async {
    try {
      // Fetch and count Users
      var usersSnapshot = await _firestore.collection('users').get();
      userCount.value = usersSnapshot.size;

      // Fetch and count Products
      var productsSnapshot = await _firestore.collection('new_arrivals').get();
      productCount.value = productsSnapshot.size;

      // Fetch and count Orders
      var ordersSnapshot = await _firestore.collection('orders').get();
      orderCount.value = ordersSnapshot.size;

      // Fetch and count Categories
      var categoriesSnapshot = await _firestore.collection('categories').get();
      categoryCount.value = categoriesSnapshot.size;

      // Fetch and count Orders
      var paymentSnapshot = await _firestore.collection('payments').get();
      paymentCount.value = paymentSnapshot.size;

      // Fetch and count Categories
      var bannerSnapshot = await _firestore.collection('banners').get();
      bannerCount.value = bannerSnapshot.size;

      // Fetch and count Categories
      var brandSnapshot = await _firestore.collection('brand').get();
      brandCount.value = brandSnapshot.size;

      // Fetch recent orders (you can limit this to the last 5 orders, for example)
      var recentOrdersSnapshot =
          await _firestore.collection('orders').orderBy('orderId').get();

      // Convert the snapshot to a list of OrderModel objects
      recentOrders.value = recentOrdersSnapshot.docs
          .map((doc) => OrderItem.fromMap(doc.data()))
          .toList();
    } catch (e) {
      // Handle errors here (you can also use a snackbar to show errors)
      Get.snackbar('Error', 'Failed to load dashboard data');
      print(e);
    }
  }
}
