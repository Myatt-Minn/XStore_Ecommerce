import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  RxList<Product> productList = <Product>[].obs;
  RxList<Product> popularProducts = <Product>[].obs;
  var currentBanner = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchPopular();
  }

  @override
  void onReady() {
    super.onReady();
    fetchProducts();
    fetchPopular();
  }

  Future<void> fetchProducts() async {
    try {
      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('new_arrivals').get();

      // Map Firestore data to the Product model
      productList.value = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    }
  }

  Future<void> fetchPopular() async {
    try {
      // Reference to your Firestore collection
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('popular_products').get();

      // Map Firestore data to the Product model
      popularProducts.value = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    }
  }

// Function to change the current page
  void changePage(int value) {
    currentBanner.value = value;
  }
}
