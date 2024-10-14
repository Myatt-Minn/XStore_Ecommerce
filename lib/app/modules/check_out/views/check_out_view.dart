import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/cart_model.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';

import '../controllers/check_out_controller.dart';

class CheckOutView extends GetView<CheckOutController> {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Check Out',
          style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Get.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        // Wrap the body with SingleChildScrollView
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            // Contact Information Section
            _buildContactInformation(context),
            const SizedBox(height: 12),

            // Address Section
            _buildAddressSection(),
            const SizedBox(height: 18),

            // Cart Items Section
            _buildCartItems(cartController),

            // Total Cost and Payment Buttons Section
            _buildSummarySection(cartController),
          ],
        ),
      ),
    );
  }

  // Contact Information Widget
  Widget _buildContactInformation(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Contact Information",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          _CustomTextField(
            controller: controller.nameController,
            icon: Icons.person_outline,
            hintText: 'Name',
          ),
          const SizedBox(height: 8),
          _CustomTextField(
            controller: controller.phoneNumberController,
            icon: Icons.phone_outlined,
            hintText: 'Phone Number',
          ),
        ],
      ),
    );
  }

  // Address Information Widget
  Widget _buildAddressSection() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Text(
            "Address",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(
            height: 8,
          ),
          _CustomTextField(
            controller: controller.addressController,
            icon: Icons.home_outlined,
            hintText: 'Address Detail',
          ),
        ],
      ),
    );
  }

  // Cart Items List Widget
  Widget _buildCartItems(CartController cartController) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your Item(s)',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            physics:
                const NeverScrollableScrollPhysics(), // Prevents the ListView from scrolling
            shrinkWrap: true, // Allow ListView to take only the space it needs
            itemCount: cartController.cartItems.length,
            itemBuilder: (context, index) {
              final CartItem item = cartController.cartItems[index];
              return Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Product Image
                    Image.network(
                      item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 10),
                    // Product Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black)),
                        const SizedBox(height: 5),
                        Text(
                          '${item.price} MMK',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          'Size: ${item.size}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      );
    });
  }

  Widget _buildSummarySection(CartController cartController) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Obx(() {
          return Column(
            children: [
              _summaryRow('Subtotal', '${cartController.totalAmount} MMK'),
              _summaryRow('Delivery Fees', '${ConstsConfig.deliveryfee} MMK'),
              _summaryRow('Total Cost', '${controller.finaltotalcost} MMK'),
            ],
          );
        }),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              return controller.isLoading.value
                  ? const CircularProgressIndicator()
                  : Expanded(
                      child: _buildPaymentButton(
                        label: 'Cash on Delivery',
                        color: Colors.grey[800]!,
                        onPressed: () {
                          controller.setOrder()
                              ? controller.confirmPayment()
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
                color: Colors.green[300]!,
                onPressed: () {
                  controller.setOrder()
                      ? Get.toNamed('/payment', arguments: {
                          "name": controller.nameController.text,
                          "phoneNumber": controller.phoneNumberController.text,
                          "address": controller.addressController.text,
                          "totalCost": controller.finaltotalcost
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

// Custom Summary Row Widget
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
}

// Custom TextField for input fields
class _CustomTextField extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;

  const _CustomTextField(
      {required this.icon, required this.hintText, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
      ),
    );
  }
}
