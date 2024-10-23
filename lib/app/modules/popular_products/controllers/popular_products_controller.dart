import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

class PopularProductsController extends GetxController {
  //TODO: Implement PopularProductsController
  RxList<Product> products = <Product>[].obs; // List of all products
  RxList<Product> filteredProducts =
      <Product>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      // Reference to your Firestore collection
      isLoading.value = true;

      // Query Firestore to get only products where "popular" is true
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('new_arrivals')
          .where('popular', isEqualTo: true) // Filter for popular products
          .get();

      // Map Firestore data to the Product model
      products.value = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<dynamic, dynamic>);
      }).toList();

      isLoading.value = false;
      filteredProducts.assignAll(products);
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to fetch popular products');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredProducts.assignAll(products);
    } else {
      filteredProducts.assignAll(
        products
            .where((product) =>
                product.name!.toLowerCase().contains(query.toLowerCase()) ||
                product.brand!.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }
}
