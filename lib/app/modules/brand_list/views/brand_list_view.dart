import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';

import '../controllers/brand_list_controller.dart';

class BrandListView extends GetView<BrandListController> {
  const BrandListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brand List'),
        backgroundColor: const Color(0xFF95CCA9), // Matching the appbar color
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar and Add Order Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/add-brand');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Brand +'),
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
            // Order Table
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
                                DataColumn(label: Text('Brand')),
                                DataColumn(label: Text('Title')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: List.generate(
                                controller.brandList.length,
                                (index) {
                                  final branditem = controller.brandList[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(
                                        FancyShimmerImage(
                                          imageUrl: branditem
                                              .imgUrl, // Replace with your product image URL
                                          width: 50,
                                          height: 50,
                                          errorWidget: const Icon(Icons.error),
                                        ),
                                      ),
                                      DataCell(Text(branditem.title)),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                controller
                                                    .deletebrand(branditem.id);
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
