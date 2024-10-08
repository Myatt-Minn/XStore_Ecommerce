import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

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
            Obx(() => Column(
                  children: [
                    PaymentOption(
                      name: ConstsConfig.kpayname,
                      phone: ConstsConfig.kpaynumber,
                      image: 'images/kbzpay.png',
                      isSelected: controller.selectedPayment.value == 'KBZPay',
                      onSelect: () => controller.selectPayment('KBZPay'),
                    ),
                    PaymentOption(
                      name: ConstsConfig.ayapayname,
                      phone: ConstsConfig.ayapaynumber,
                      image: 'images/aya.png',
                      isSelected: controller.selectedPayment.value == 'AYABank',
                      onSelect: () => controller.selectPayment('AYABank'),
                    ),
                  ],
                )),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload_file,
                                  size: 40, color: Colors.grey),
                              const SizedBox(height: 8),
                              controller.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text('Click here image upload')
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
            ElevatedButton(
              onPressed: () => controller.confirmPayment(),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: Colors.green,
              ),
              child: const Text('Confirm',
                  style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        margin: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? Colors.green : Colors.grey),
        ),
        child: Row(
          children: [
            Image.asset(image, height: 40, width: 40),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                Text(phone,
                    style: const TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
            const Spacer(),
            isSelected
                ? const Icon(Icons.check_circle, color: Colors.green)
                : const Icon(Icons.radio_button_unchecked),
          ],
        ),
      ),
    );
  }
}
