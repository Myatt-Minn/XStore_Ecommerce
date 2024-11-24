import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/deliveryFees_list/controllers/delivery_fees_list_controller.dart';

class DeliveryFeesListView extends GetView<DeliveryFeesListController> {
  const DeliveryFeesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Delivery Fees List',
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
            // Add Region Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/add-delivery-fee');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Region',
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

            // Display Regions and Cities
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
                              DataColumn(label: Text('Region')),
                              DataColumn(label: Text('City')),
                              DataColumn(label: Text('Delivery Fee')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: controller.regions.expand((region) {
                              return region.cities.map((city) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(region.name)),
                                    DataCell(Text(city.name)),
                                    DataCell(Text('${city.deliveryFee} MMK')),
                                    DataCell(
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: const Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              controller.deleteCity(
                                                  region.id, city.name);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              }).toList();
                            }).toList(),
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
