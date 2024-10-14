import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Choose Payment', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            // Wrap the payment options in an Obx to observe changes
            Obx(() {
              if (controller.payments.isEmpty) {
                return const CircularProgressIndicator(); // Show loading indicator while payments load
              }

              return Column(
                children: controller.payments.map((payment) {
                  return PaymentOption(
                    name: payment['name'],
                    phone: payment[
                        'phone'], // Assuming each payment has a 'phone' field
                    image: payment['imgUrl'],
                    isSelected:
                        controller.selectedPayment.value == payment['title'],
                    onSelect: () => controller.selectPayment(payment['title']),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 16),
            const Text('Upload Screenshot of Payment transaction',
                style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => controller.chooseImage(),
              child: Obx(
                () => Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: controller.profileImg.value == ""
                      ? Center(
                          child: controller.isLoading.value
                              ? const CircularProgressIndicator()
                              : const Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.upload_file,
                                        size: 40, color: Colors.grey),
                                    SizedBox(height: 8),
                                    Text('Click here image upload')
                                  ],
                                ),
                        )
                      : Image.network(
                          controller.profileImg.value,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
            ),
            const Spacer(),
            Obx(() {
              return ElevatedButton(
                onPressed: () => controller.confirmPayment(),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  backgroundColor: Colors.green,
                ),
                child: controller.isOrder.value
                    ? const CircularProgressIndicator()
                    : const Text('Confirm',
                        style: TextStyle(fontSize: 18, color: Colors.white)),
              );
            }),
            const SizedBox(height: 8),
            const Text(
              'Note: Please upload the screenshot of your payment transaction to complete your payment',
              style: TextStyle(color: Color.fromARGB(255, 130, 130, 130)),
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentOption extends StatelessWidget {
  final String name;
  final String phone;
  final String image;
  final bool isSelected;
  final VoidCallback onSelect;

  const PaymentOption({
    super.key,
    required this.name,
    required this.phone,
    required this.image,
    required this.isSelected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: ListTile(
        leading: Image.network(image), // Use network image from Firestore
        title: Text(name),
        subtitle: Text(phone),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.radio_button_unchecked),
      ),
    );
  }
}
