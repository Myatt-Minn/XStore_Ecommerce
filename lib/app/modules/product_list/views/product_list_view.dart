import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';

import '../controllers/product_list_controller.dart';

class ProductListView extends GetView<ProductListController> {
  const ProductListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products List'),
        backgroundColor: const Color(0xFF95CCA9),
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      controller.searchProducts(value); // Call search on change
                    },
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search products',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      fillColor: const Color(0xFFF4F5F7),
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/add-product');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Product +'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF95CCA9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Obx(() {
              return controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('ID')),
                              DataColumn(label: Text('Product')),
                              DataColumn(label: Text('Product Name')),
                              DataColumn(label: Text('Category Name')),
                              DataColumn(label: Text('Brand Name')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: List.generate(
                              controller.filteredList
                                  .length, // Change to filteredList
                              (index) {
                                final productitem =
                                    controller.filteredList[index];
                                return DataRow(
                                  cells: [
                                    DataCell(Text('${index + 1}')),
                                    DataCell(
                                      FancyShimmerImage(
                                        imageUrl: productitem.images![0],
                                        width: 50,
                                        height: 50,
                                        errorWidget: const Icon(Icons.error),
                                      ),
                                    ),
                                    DataCell(Text(productitem.name!)),
                                    DataCell(Text(productitem.category!)),
                                    DataCell(Text(productitem.brand!)),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.edit,
                                                color: Colors.blue),
                                            onPressed: () {
                                              Get.toNamed('/edit-product',
                                                  arguments: productitem.id);
                                            },
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              controller.deleteProduct(
                                                  productitem.id!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    );
            }),
          ],
        ),
      ),
    );
  }
}
