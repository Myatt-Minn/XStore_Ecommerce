import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';
import 'package:xstore/app/modules/check_out/controllers/check_out_controller.dart';
import 'package:xstore/app/modules/check_out/views/widgets/AddressSection%20.dart';
import 'package:xstore/app/modules/check_out/views/widgets/CartItems%20.dart';
import 'package:xstore/app/modules/check_out/views/widgets/SummarySection%20.dart';
import 'package:xstore/app/modules/check_out/views/widgets/contactInformation%20.dart';

class CheckOutView extends GetView<CheckOutController> {
  const CheckOutView({super.key});

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Check Out',
            style:
                TextStyle(color: Get.isDarkMode ? Colors.white : Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Get.isDarkMode ? Colors.white : Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          children: [
            ContactInformation(
              nameController: controller.nameController,
              phoneNumberController: controller.phoneNumberController,
            ),
            const SizedBox(height: 12),
            AddressSection(),
            const SizedBox(height: 18),
            CartItems(cartController: cartController),
            SummarySection(
              cartController: cartController,
              checkOutController: controller,
            ),
          ],
        ),
      ),
    );
  }
}
