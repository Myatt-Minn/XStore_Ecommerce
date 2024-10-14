import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:xstore/app/data/product_model.dart';

class ProductListController extends GetxController {
  var isLoading = false.obs;
  var productList = <Product>[].obs;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var categories = <String>[].obs; // List of categories from Firestore
  var brands = <String>[].obs; // List of brands from Firestore
  var selectedCategory = ''.obs;
  var selectedBrand = ''.obs;
  var filteredList = <Product>[].obs; // To hold filtered products

  var searchQuery = ''.obs; // To hold the search query

  var isEditingSize = false.obs;
  var currentEditIndex = -1.obs;
  var productName = ''.obs;
  var description = ''.obs;
  var sizes = <Map<String, dynamic>>[].obs;
  var images = <XFile>[].obs;
  var imageUrls = <String>[].obs;

  final TextEditingController productNameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sizeController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  var formKey = GlobalKey<FormState>(); // Form key for validation

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    fetchCategories();
    fetchBrands();
  }

  // Validate size, price, and quantity fields
  bool validateSizeFields() {
    return sizeController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        quantityController.text.isNotEmpty;
  }

  // Clear size, price, and quantity fields after adding
  void clearSizeFields() {
    sizeController.clear();
    priceController.clear();
    quantityController.clear();
  }

// Function to delete an image
  void deleteImage(String imageUrl) {
    imageUrls.remove(imageUrl);
    // Add code to also remove from Firestore if needed
  }

// Fetch products from Firestore
  Future<void> fetchProducts() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('new_arrivals').get();

      productList.value = snapshot.docs.map((doc) {
        final data = doc.data() as Map<dynamic, dynamic>?;
        if (data == null) {
          throw Exception('Null data in document');
        }
        return Product.fromJson(data);
      }).toList();
      filteredList.assignAll(productList);
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch products');
      isLoading.value = false;
    }
  }

  // Fetch categories from Firestore
  Future<void> fetchCategories() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('categories').get();
      categories.value =
          snapshot.docs.map((doc) => doc['title'] as String).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories');
    }
  }

  // Fetch brands from Firestore
  Future<void> fetchBrands() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('brand').get();
      brands.value =
          snapshot.docs.map((doc) => doc['title'] as String).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch brands');
    }
  }

  void searchProducts(String query) {
    searchQuery.value = query; // Update the search query

    // If the query is empty, show all products
    if (query.isEmpty) {
      filteredList.assignAll(productList);
    } else {
      // Filter the product list based on the search query
      filteredList.assignAll(productList.where((product) {
        return product.name!.toLowerCase().contains(query.toLowerCase()) ||
            product.category!.toLowerCase().contains(query.toLowerCase()) ||
            product.brand!.toLowerCase().contains(query.toLowerCase());
      }).toList());
    }
  }

// Pick multiple images
  Future<void> pickImages() async {
    final pickedFiles = await _picker.pickMultiImage();
    images.addAll(pickedFiles);
  }

  Future<List<String>> uploadImages() async {
    List<String> downloadUrls = [];

    for (var image in images) {
      String fileName = image.path.split('/').last;
      Reference firebaseStorageRef =
          FirebaseStorage.instance.ref().child('product_images/$fileName');
      UploadTask uploadTask = firebaseStorageRef.putFile(File(image.path));

      TaskSnapshot taskSnapshot = await uploadTask;
      String downloadUrl = await taskSnapshot.ref.getDownloadURL();
      downloadUrls.add(downloadUrl);
      imageUrls.add(downloadUrl); // Add the download URL to the list
    }

    return downloadUrls;
  }

  Future<void> addProductToFirestore() async {
    try {
      isLoading.value = true;
      await uploadImages();
      final docRef =
          FirebaseFirestore.instance.collection('new_arrivals').doc();

      Map<String, dynamic> product = {
        'id': docRef.id,
        'name': productName.value,
        'description': description.value,
        'category': selectedCategory.value,
        'sizes': sizes,
        'brand': selectedBrand.value,
        'image': imageUrls,
      };

      await docRef.set(product);
      Get.snackbar('Success', 'Product added successfully',
          backgroundColor: Colors.green[300]);
      fetchProducts();
      isLoading.value = false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add product');
      isLoading.value = false;
    }
  }

  // Function to delete an order
  Future<void> deleteProduct(String orderId) async {
    try {
      // Delete the order document from the "orders" collection
      await FirebaseFirestore.instance
          .collection('new_arrivals')
          .doc(orderId)
          .delete();
      fetchProducts();

      Get.snackbar('Success', 'Product deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green[100],
          colorText: Colors.black);
    } catch (e) {
      // Handle any errors that occur during deletion
      Get.snackbar('Error', 'Failed to delete product: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red[100],
          colorText: Colors.black);
    }
  }

  Future<void> loadSpecificProduct(String productId) async {
    try {
      DocumentSnapshot doc =
          await firestore.collection('new_arrivals').doc(productId).get();
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

      productNameController.text = data['name'];
      descriptionController.text = data['description'];
      selectedCategory.value = data['category'];
      selectedBrand.value = data['brand'];
      sizes.value = List<Map<String, dynamic>>.from(data['sizes']);
      imageUrls.value = List<String>.from(data['image']);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product');
    }
  }

  // Method to add size data
  void addSize(int size, int price, int quantity) {
    try {
      sizes.add({
        'size': size,
        'price': price,
        'quantity': quantity,
      });
      clearSizeFields();
    } catch (e) {
      Get.snackbar("Error", "Please fill the input fields first!",
          backgroundColor: Colors.red);
    }
  }

  // Set size for editing
  void setSizeForEditing(int index) {
    final sizeData = sizes[index];
    sizeController.text = sizeData['size'].toString();
    priceController.text = sizeData['price'].toString();
    quantityController.text = sizeData['quantity'].toString();
    isEditingSize.value = true;
    currentEditIndex = index;
  }

  // Delete size
  void deleteSize(int index) {
    sizes.remove(sizes[index]);
  }

//Update existing size
  void updateSize(int size, int price, int quantity) {
    try {
      if (currentEditIndex >= 0) {
        sizes[currentEditIndex] = {
          'size': size,
          'price': price,
          'quantity': quantity,
        };
        isEditingSize.value = false;
        currentEditIndex = -1;
        clearSizeFields();
      } else {
        Get.snackbar("Error", "Please select size first!",
            backgroundColor: Colors.red);
      }
    } catch (e) {
      Get.snackbar("Error", "Please select size first!",
          backgroundColor: Colors.red);
    }
  }

  // Update the product in Firestore
  Future<void> updateProductInFirestore(String productId) async {
    isLoading.value = true;

    try {
      // Upload new images if there are any
      if (images.isNotEmpty) {
        imageUrls.addAll(await uploadImages());
      }

      await firestore.collection('new_arrivals').doc(productId).update({
        'name': productNameController.text.trim(),
        'description': descriptionController.text.trim(),
        'category': selectedCategory.value,
        'brand': selectedBrand.value,
        'sizes': sizes,
        'image': imageUrls,
      });

      Get.snackbar('Success', 'Product updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update product: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
