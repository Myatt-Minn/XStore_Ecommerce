import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/category_list_controller.dart';

class CategoryListView extends GetView<CategoryListController> {
  const CategoryListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories List',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, // Set your desired color here
        ),
        backgroundColor: ConstsConfig.primarycolor, // Matching the appbar color
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar and Add Product Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add product action
                    Get.toNamed('/add-category');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Category',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ConstsConfig.secondarycolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Product Table
            Obx(() {
              return controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Category')),
                                DataColumn(label: Text('Title')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: List.generate(
                                controller.categoryList.length,
                                (index) {
                                  final categoryitem =
                                      controller.categoryList[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(FancyShimmerImage(
                                        imageUrl: categoryitem
                                            .imgUrl, // Replace with your product image URL
                                        width: 50,
                                        height: 50,
                                        errorWidget: const Icon(Icons.error),
                                      )),
                                      DataCell(Text(categoryitem.title)),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                controller.deletecategory(
                                                    categoryitem.id);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              )),
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
