import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/admin_panel_controller.dart';

class AdminPanelView extends GetView<AdminPanelController> {
  const AdminPanelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          buildMenuItem(context, Icons.dashboard, 'Dashboard', Colors.grey,
              () => Get.toNamed('/admin-dashboard')),
          buildMenuItem(context, Icons.person, 'User List', Colors.grey,
              () => Get.toNamed('/customer-list')),
          buildMenuItem(context, Icons.list_alt, 'Order List', Colors.grey,
              () => Get.toNamed('/order-list')),
          buildMenuItem(context, Icons.category, 'Category', Colors.grey,
              () => Get.toNamed('/category-list')),
          buildMenuItem(context, Icons.branding_watermark, 'Brand', Colors.grey,
              () => Get.toNamed('/brand-list')),
          buildMenuItem(context, Icons.production_quantity_limits, 'Products',
              Colors.grey, () => Get.toNamed('/product-list')),
          buildMenuItem(context, Icons.image, 'Banner', Colors.grey,
              () => Get.toNamed('/banner-list')),
          buildMenuItem(context, Icons.payment, 'Payment', Colors.grey,
              () => Get.toNamed('/payment-list')),
          buildMenuItem(context, Icons.payment, 'Pravicy Policy', Colors.grey,
              () => Get.toNamed('/add-privacy')),
          buildMenuItem(context, Icons.message, 'SendNotification', Colors.grey,
              () => Get.toNamed('/send-notification')),
          buildMenuItem(
            context,
            Icons.logout,
            'LogOut',
            Colors.grey,
            () => FirebaseAuth.instance.signOut(),
          )
        ],
      ),
    );
  }

  Widget buildMenuItem(BuildContext context, IconData icon, String title,
      Color iconColor, Function onPressed) {
    return ListTile(
      leading: Icon(icon, color: iconColor),
      title: Text(title),
      onTap: () {
        onPressed(); // Invoke the passed function
      },
    );
  }
}
