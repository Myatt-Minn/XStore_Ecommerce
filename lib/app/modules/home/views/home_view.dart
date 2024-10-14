import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';
import 'package:xstore/app/modules/navigation_screen/controllers/navigation_screen_controller.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // App bar with logo and notification icon
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'images/logo.png', // Add your app logo here
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Ecommerce App",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Sneaker Store",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Obx(() => Stack(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.shopping_cart),
                            onPressed: () {
                              // Navigate to Cart Page
                              Get.find<NavigationScreenController>()
                                  .currentIndex
                                  .value = 2;
                            },
                          ),
                          if (cartController.itemCount >
                              0) // Show badge only if there are items
                            Positioned(
                              right: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                child: Text(
                                  '${cartController.itemCount}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                        ],
                      )),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GestureDetector(
                onTap: () {
                  Get.find<NavigationScreenController>().currentIndex.value =
                      1; // Navigate to filter screen
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // Same fill color
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.search), // Search Icon
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          "Search products, brands...",
                          style: TextStyle(
                              color: Colors.black54,
                              fontSize: 16), // Hint text styling
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {
                          Get.find<NavigationScreenController>()
                              .currentIndex
                              .value = 1; // Navigate to filter screen
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Obx(() {
              if (controller.banners.isEmpty) {
                return const CircularProgressIndicator(); // Show loading indicator while banners load
              }

              return SizedBox(
                height: 180,
                child: PageView.builder(
                  onPageChanged: controller.changePage,
                  controller: controller
                      .pageController, // Use the PageController from the controller
                  itemCount: controller.banners.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      controller.banners[index],
                      fit: BoxFit.cover,
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 20),
            // Dots Indicator
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    controller.banners
                        .length, // Generate dots based on the number of banners
                    (index) => buildDot(index, controller.currentBanner.value),
                  ),
                )),

            const SizedBox(height: 10),
            // Category Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Category",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.find<NavigationScreenController>()
                          .currentIndex
                          .value = 1;
                    },
                    child: const Text(
                      "See all >",
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Adjusted Category ListView with Proper Height
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryIcon('Nike', 'images/Nike.png'),
                  _buildCategoryIcon('Adidas', 'images/adidas.png'),
                  _buildCategoryIcon('New Balance', 'images/NB.png'),
                  _buildCategoryIcon('Converse', 'images/converse.png'),
                ],
              ),
            ),

            const SizedBox(height: 20),
            // Popular Shoes Section
            buildSectionHeader("Popular Shoes", () {
              // Add navigation to "See all" functionality here
            }),
            const SizedBox(height: 10),
            Obx(() {
              return controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : SizedBox(
                      height: 220, // Height for the horizontal list
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.popularProducts
                            .length, // Replace with actual data length
                        itemBuilder: (context, index) {
                          return buildProductCard(
                              controller.productList[index]);
                        },
                      ),
                    );
            }),

            const SizedBox(height: 20),

            // New Arrivals Section
            buildSectionHeader("New Arrivals", () {
              // Add navigation to "See all" functionality here
            }),
            Obx(() {
              if (controller.productList.isEmpty) {
                return const Text("No products available.");
              }
              return controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.productList
                          .length, // Replace with actual data length
                      itemBuilder: (context, index) {
                        return buildProductListItem(
                            controller.productList[index]);
                      },
                    );
            })
          ],
        ),
      ),
    );
  }

// Build the section header with "See all"
  Widget buildSectionHeader(String title, VoidCallback onSeeAll) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text("See all", style: TextStyle(color: Colors.grey)),
                Icon(Icons.arrow_forward_ios, size: 12, color: Colors.grey),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Build horizontal product card for "Popular Shoes"
  Widget buildProductCard(Product product) {
    return InkWell(
      onTap: () {
        Get.toNamed('/product-details', arguments: product);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          width: 180,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FancyShimmerImage(
                imageUrl: product.images!.isNotEmpty
                    ? product.images![0]
                    : 'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                height: 100,
                width: double.infinity,
                boxFit: BoxFit.contain,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black)),
                    Text(
                      product.brand!,
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        product.sizes != null && product.sizes!.isNotEmpty
                            ? Text(
                                "${product.sizes![0]['price']}MMK",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 16),
                              )
                            : const Text("NO sizes")
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build vertical product item for "New Arrivals"
  Widget buildProductListItem(Product product) {
    return InkWell(
      onTap: () {
        Get.toNamed('/product-details', arguments: product);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 5.0,
                spreadRadius: 2.0,
              ),
            ],
          ),
          child: Row(
            children: [
              FancyShimmerImage(
                imageUrl: product.images!.isNotEmpty
                    ? product.images![0]
                    : 'https://img.freepik.com/premium-vector/default-image-icon-vector-missing-picture-page-website-design-mobile-app-no-photo-available_87543-11093.jpg',
                height: 100,
                width: 100,
                boxFit: BoxFit.contain,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(product.name!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.black)),
                      Text(
                        product.brand!,
                        style: const TextStyle(color: Colors.blue),
                      ),
                      const SizedBox(height: 4),
                      product.sizes != null && product.sizes!.isNotEmpty
                          ? Text(
                              "${product.sizes![0]['price']} MMK",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            )
                          : const Text('no size available'),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Get.toNamed('/product-details', arguments: product);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    backgroundColor: const Color(0xFF95CCA9),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper for building category icon widgets
  Widget _buildCategoryIcon(String name, String imagePath) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: AssetImage(imagePath),
          ),
          const SizedBox(height: 5),
          Text(name),
        ],
      ),
    );
  }

  // Dot builder for the page indicator
  Widget buildDot(int index, int currentPage) {
    return Container(
      height: 10.0,
      width: currentPage == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
