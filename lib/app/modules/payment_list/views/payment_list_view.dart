import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';
import 'package:xstore/app/data/consts_config.dart';

import '../controllers/payment_list_controller.dart';

class PaymentListView extends GetView<PaymentListController> {
  const PaymentListView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Payments List',
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
            // Search Bar and Add Payment Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Get.toNamed('/add-payment');
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Add Payment',
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
            // Payment Table
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
                                DataColumn(label: Text('Payment')),
                                DataColumn(label: Text('Payment Title')),
                                DataColumn(label: Text('PhoneNumber')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Actions')),
                              ],
                              rows: List.generate(
                                controller.paymentList.length,
                                (index) {
                                  final paymentitem =
                                      controller.paymentList[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text('${index + 1}')),
                                      DataCell(
                                        FancyShimmerImage(
                                          imageUrl: paymentitem
                                              .imgUrl, // Replace with your product image URL
                                          width: 40,
                                          height: 40,
                                          errorWidget: const Icon(Icons.error),
                                        ),
                                      ),
                                      DataCell(Text(paymentitem.title)),
                                      DataCell(Text(paymentitem.phone)),
                                      DataCell(Text(paymentitem.name)),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.delete,
                                                  color: Colors.red),
                                              onPressed: () {
                                                // Delete action
                                                controller.deletepayment(
                                                    paymentitem.id);
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
