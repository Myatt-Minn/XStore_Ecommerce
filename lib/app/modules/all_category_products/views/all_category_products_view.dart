import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';
import 'package:xstore/global_widgets/productCard.dart';

import '../controllers/all_category_products_controller.dart';

class AllCategoryProductsView extends GetView<AllCategoryProductsController> {
  const AllCategoryProductsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All ${controller.categorygg!.value}'),
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
              return controller.filteredProducts.isEmpty
                  ? const Center(
                      child: Text("No products of this category."),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.8,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: controller.filteredProducts.length,
                      itemBuilder: (context, index) {
                        Product product = controller.filteredProducts[index];
                        return ProductCard(
                          product: product,
                        );
                      },
                    );
            }),
          ),
        ],
      ),
    );
  }
}