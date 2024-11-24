import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/add_delivery_fee_controller.dart';

class AddDeliveryFeeView extends GetView<AddDeliveryFeeController> {
  const AddDeliveryFeeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Delivery Fee',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: ConstsConfig.primarycolor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Region Name Field
                      const Text(
                        'Region Name',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: controller.regionNameController,
                        decoration: InputDecoration(
                          hintText: 'Enter region name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // City Name and Delivery Fee Fields
                      const Text(
                        'Add Cities and Delivery Fees',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: controller.cityNameController,
                              decoration: InputDecoration(
                                hintText: 'City Name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            flex: 1,
                            child: TextField(
                              controller: controller.deliveryFeeController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Fee',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: controller.addCity,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ConstsConfig.secondarycolor,
                            ),
                            child: const Icon(Icons.add),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // City List
                      Obx(() {
                        return Column(
                          children:
                              List.generate(controller.cities.length, (index) {
                            final city = controller.cities[index];
                            return ListTile(
                              title: Text(city.name),
                              subtitle: Text('${city.deliveryFee} MMK'),
                              trailing: IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => controller.removeCity(index),
                              ),
                            );
                          }),
                        );
                      }),
                      const SizedBox(height: 16),

                      // Save Button
                      Center(
                        child: ElevatedButton.icon(
                          onPressed: controller.saveRegion,
                          icon: const Icon(Icons.save),
                          label: const Text('Save Region'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ConstsConfig.primarycolor,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
        }),
      ),
    );
  }
}
