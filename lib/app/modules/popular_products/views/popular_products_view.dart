import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

import '../controllers/popular_products_controller.dart';

class PopularProductsView extends GetView<PopularProductsController> {
  const PopularProductsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Popular Products'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: TextField(
              onChanged: (value) {
                controller.searchProducts(value);
              },
              decoration: InputDecoration(
                labelText: "Search Products",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
          // GridView to show products
          Expanded(
            child: Obx(() {
              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: controller.filteredProducts.length,
                itemBuilder: (context, index) {
                  Product product = controller.filteredProducts[index];
                  return _buildProductCard(product);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // The product card widget is reused here
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
                  topLeft: Radius.circular(15), topRight: Radius.circular(15)),
              child: FancyShimmerImage(
                imageUrl: product.images![0],
                width: double.infinity,
                height: 120,
                boxFit: BoxFit.cover,
              ),
            ),
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
                        "${product.sizes![0]['price']} MMK",
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
