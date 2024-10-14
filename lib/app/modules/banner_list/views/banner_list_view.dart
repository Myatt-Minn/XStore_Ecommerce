import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';

import '../controllers/banner_list_controller.dart';

class BannerListView extends GetView<BannerListController> {
  const BannerListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Banners List'),
        backgroundColor: const Color(0xFF95CCA9), // Matching the appbar color
        actions: const [],
      ),
      drawer: const AdminDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Search Bar and Add Banner Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Add Banner action
                    Get.toNamed('/add-banner');
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add Banner +'),
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
                                DataColumn(label: Text('Banner')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: List.generate(
                                controller.bannerList.length,
                                (index) {
                                  final banneritem =
                                      controller.bannerList[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(FancyShimmerImage(
                                        imageUrl: banneritem
                                            .imgUrl, // Replace with your product image URL
                                        width: 70,
                                        height: 70,
                                        errorWidget: const Icon(Icons.error),
                                      )),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                controller.deleteBanner(
                                                    banneritem.id);
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
