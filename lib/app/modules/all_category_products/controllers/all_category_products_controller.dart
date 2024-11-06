import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

class AllCategoryProductsController extends GetxController {
  //TODO: Implement AllCategoryProductsController

  RxList<Product> products = <Product>[].obs; // List of all products
  RxList<Product> filteredProducts =
      <Product>[].obs; // Filtered list based on search
  RxString searchQuery = ''.obs;
  RxBool isLoading = false.obs;
  RxString? categorygg = ''.obs;
  @override
  void onInit() {
    super.onInit();
    categorygg!.value = Get.arguments;
    fetchProducts(category: categorygg!.value);
  }

  Future<void> fetchProducts({required String category}) async {
    try {
      isLoading.value = true;

      // Query Firestore to get products based on the 'category' field
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('new_arrivals')
          .where('category', isEqualTo: category)
          .get();

      // Map Firestore data to the Product model with null checks
      products.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return Product.fromJson(data);
      }).toList();

      // Update the filteredProducts list
      filteredProducts.assignAll(products);
    } catch (e, stacktrace) {
      print('Error: $e');
      print('Stacktrace: $stacktrace');

      // Display error in the UI
      Get.snackbar('Error', 'Failed to fetch products');
    } finally {
      isLoading.value = false;
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
