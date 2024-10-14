import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';
import 'package:xstore/app/modules/category/controllers/category_controller.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.category),
        title: const Text('Category',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category and Brand Tabs
            Row(
              children: [
                _buildCategoryTab('Category'),
                _buildCategoryTab('Brand'),
              ],
            ),
            const SizedBox(height: 20),
            // Search Bar
            _buildSearchBar(),
            const SizedBox(height: 15),
            // Show either the brand or category content based on the selected tab
            Obx(() {
              if (controller.selectedCategory.value == 'Category') {
                // Show category-based product grid
                return Expanded(
                  child: Column(
                    children: [
                      // Horizontal list of circular category icons
                      _buildCategoryIcons(),
                      const SizedBox(height: 20),
                      // Grid of Products
                      controller.productList.isEmpty
                          ? const Center(
                              child: Text("There is no products yet!"),
                            )
                          : Expanded(
                              child: Obx(
                                () => GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: controller.filteredProducts.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        controller.filteredProducts[index];
                                    return _buildProductCard(product);
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              } else {
                // Show brand-based view
                return Expanded(
                  child: Column(
                    children: [
                      // Horizontal list of circular category icons
                      _buildBrandScreen(),
                      const SizedBox(height: 20),
                      // Grid of Products
                      controller.productsByBrand.isEmpty
                          ? const Center(
                              child: Text("There is no products yet!"),
                            )
                          : Expanded(
                              child: Obx(
                                () => GridView.builder(
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 0.7,
                                    crossAxisSpacing: 15,
                                    mainAxisSpacing: 15,
                                  ),
                                  itemCount: controller.filteredBrand.length,
                                  itemBuilder: (context, index) {
                                    final product =
                                        controller.filteredBrand[index];
                                    return _buildProductCard(product);
                                  },
                                ),
                              ),
                            ),
                    ],
                  ),
                );
              }
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildBrandScreen() {
    return SizedBox(
      height: 110, // Height for the circular icons list
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.brands.length,
            itemBuilder: (context, index) {
              final brand = controller.brands[index];
              return _buildBrandCircle(brand.title, brand.imgUrl);
            },
          )),
    );
  }

  // Helper method to build brand circle icon widgets
  Widget _buildBrandCircle(String brandName, String imagePath) {
    return GestureDetector(
      onTap: () {
        controller.getProductsByBrand(brandName);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(
                  imagePath), // Replace with your actual brand images
            ),
            const SizedBox(height: 5),
            Text(brandName, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Tab button widget (Category / Brand)
  Widget _buildCategoryTab(String label) {
    return Expanded(
      child: Obx(
        () => GestureDetector(
          onTap: () {
            controller.selectedCategory.value = label;
          },
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: controller.selectedCategory.value == label
                  ? Colors.green[300]
                  : Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 16,
                color: controller.selectedCategory.value == label
                    ? Colors.white
                    : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Search Bar widget
  Widget _buildSearchBar() {
    return TextField(
      onChanged: (value) => controller.searchText.value = value,
      decoration: InputDecoration(
        filled: true,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        hintText: 'Search products, brands...',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return SizedBox(
      height: 110, // Height for the circular icons list
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.categories.length,
            itemBuilder: (context, index) {
              final category = controller.categories[index];
              return _buildCategoryIcon(category.imgUrl, category.title);
            },
          )),
    );
  }

  // Category Icon Widget
  Widget _buildCategoryIcon(String imagePath, String label) {
    return GestureDetector(
      onTap: () {
        controller.fetchProducts(
            category: label
                .toLowerCase()); // Fetch products for the selected category
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(imagePath),
            ),
            const SizedBox(height: 5),
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
      ),
    );
  }

  // Product Card Widget
  Widget _buildProductCard(Product product) {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/product-details', arguments: product);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                child: FancyShimmerImage(
                  imageUrl: product.images![0],
                  width: double.infinity,
                  height: 120,
                  boxFit: BoxFit.cover,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name!,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black)),
                  Text(product.brand!,
                      style: const TextStyle(color: Colors.green)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "${product.sizes![0]['price']}MMK",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
