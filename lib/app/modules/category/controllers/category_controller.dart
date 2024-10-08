import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

class CategoryController extends GetxController {
  var selectedCategory = 'Category'.obs; // Observable for category selection
  var searchText = ''.obs; // Observable for search input
  var isFavorite = false.obs;

  RxList<Product> productList = <Product>[].obs; // Observable list of products
  RxList<Product> productsByBrand = <Product>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts(); // Fetch products when the controller initializes
    getProductsByBrand('Nike');
  }

  // Fetch products from Firestore based on category
  Future<void> fetchProducts({String category = 'shoes'}) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection(category) // Use the category as the collection name
          .get();

      // Map Firestore data to the Product model
      productList.value = snapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
    }
  }

  Future<void> getProductsByBrand(String brand) async {
    try {
      // Query Firestore to retrieve products where 'brand' matches the provided brand
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('new_arrivals')
          .where('brand', isEqualTo: brand)
          .get();

      // Map Firestore documents to Product objects and update the RxList
      productsByBrand.value = querySnapshot.docs.map((doc) {
        return Product.fromJson(doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      // Handle errors, e.g., logging or showing an error message
      print('Error fetching products by brand: $e');
    }
  }

  // Add to cart
  void addToCart(Product product) {
    Get.snackbar('Cart', '${product.name} added to cart!');
  }

  // Filtered products based on search query
  List<Product> get filteredProducts {
    if (searchText.isEmpty) {
      return productList;
    } else {
      return productList
          .where((product) =>
              product.name!.toLowerCase().contains(searchText.toLowerCase()) ||
              product.brand!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }

  // Filtered products based on search query
  List<Product> get filteredBrand {
    if (searchText.isEmpty) {
      return productsByBrand;
    } else {
      return productsByBrand
          .where((product) =>
              product.name!.toLowerCase().contains(searchText.toLowerCase()) ||
              product.brand!.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    }
  }
}
