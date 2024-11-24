import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';
import 'package:xstore/app/modules/check_out/controllers/check_out_controller.dart';

class SummarySection extends StatelessWidget {
  final CartController cartController;
  final CheckOutController checkOutController;

  const SummarySection({
    super.key,
    required this.cartController,
    required this.checkOutController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Obx(() {
          return Column(
            children: [
              _summaryRow('Subtotal', '${cartController.totalAmount} MMK'),
              _summaryRow(
                  'Delivery Fees', '${checkOutController.deliveryFee} MMK'),
              _summaryRow(
                  'Total Cost', '${checkOutController.finaltotalcost} MMK'),
            ],
          );
        }),
        const SizedBox(height: 20),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              return checkOutController.isLoading.value
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: _buildPaymentButton(
                        label: 'Cash on Delivery',
                        color: Colors.grey[800]!,
                        onPressed: () {
                          checkOutController.setOrder()
                              ? checkOutController.confirmPayment()
                              : Get.snackbar("Empty TextBox",
                                  "Please fill all informations first.");
                        },
                      ),
                    );
            }),
            const SizedBox(width: 10),
            Expanded(
              child: _buildPaymentButton(
                label: 'Online Payment',
                color: ConstsConfig.secondarycolor,
                onPressed: () {
                  checkOutController.setOrder()
                      ? Get.toNamed('/payment', arguments: {
                          "name": checkOutController.nameController.text,
                          "phoneNumber":
                              checkOutController.phoneNumberController.text,
                          "address": checkOutController.addressController.text,
                          "totalCost": checkOutController.finaltotalcost,
                          "deliveryFee": checkOutController.deliveryFee.value,
                        })
                      : Get.snackbar("Empty TextBox",
                          "Please fill all informations first.");
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Custom Payment Button
  Widget _buildPaymentButton({
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _summaryRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: const TextStyle(fontSize: 16)),
          Text(value,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}
