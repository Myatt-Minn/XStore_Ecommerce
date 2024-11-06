import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';

class AppWidgets {
  static TextStyle boldTextFieldStyle() => const TextStyle(
      fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Poppins");
  static TextStyle headlineTextFieldStyle() => const TextStyle(
      fontSize: 23, fontWeight: FontWeight.bold, fontFamily: "Poppins");
  static TextStyle lightTextFieldStyle() => TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      fontFamily: "Poppins",
      color: Get.isDarkMode ? Colors.white : Colors.black38);
  static TextStyle littlelightTextFieldStyle() => TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      fontFamily: "Poppins",
      color: Get.isDarkMode ? Colors.white : Colors.black38);
  static TextStyle smallboldlineTextFieldStyle() => const TextStyle(
      fontSize: 18, fontWeight: FontWeight.bold, fontFamily: "Poppins");
}

Future<void> cloneDocument(String sourceCollection, String sourceDocId,
    String targetCollection, String targetDocId) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get the document from the source collection
  DocumentSnapshot docSnapshot =
      await firestore.collection(sourceCollection).doc(sourceDocId).get();

  if (docSnapshot.exists) {
    Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;

    // Write the document to the target collection with the new document ID
    await firestore.collection(targetCollection).doc(targetDocId).set(data);
    print("Document cloned successfully!");
  } else {
    print("Document does not exist in the source collection.");
  }
}

//  await cloneCollection('source_collection_name', 'target_collection_name');

Future<void> cloneCollection(
    String sourceCollection, String targetCollection) async {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Get all documents from the source collection
  QuerySnapshot querySnapshot =
      await firestore.collection(sourceCollection).get();

  // Iterate over each document
  for (QueryDocumentSnapshot doc in querySnapshot.docs) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Write to the target collection using the same document ID
    await firestore.collection(targetCollection).doc(doc.id).set(data);
  }
}

// await cloneDocument(
//     'shirts', '4665UmO1aPjzbYdQUHq9', 'new_arrivals', 'y9Cq3hm0OhTEIidWB4jl');

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Remove padding from ListView
        children: [
          Container(
            height: 80,
            color: ConstsConfig.primarycolor,
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: const Center(
                child: Text(
              "Admin Menu",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 21,
                  fontWeight: FontWeight.bold),
            )),
          ),
          buildMenuItem(
            context,
            Icons.dashboard,
            'Dashboard',
            Colors.grey,
            () => Get.toNamed('/admin-dashboard'),
          ),
          buildMenuItem(
            context,
            Icons.person,
            'User List',
            Colors.grey,
            () => Get.toNamed('/customer-list'),
          ),
          buildMenuItem(
            context,
            Icons.list_alt,
            'Order List',
            Colors.grey,
            () => Get.toNamed('/order-list'),
          ),
          buildMenuItem(
            context,
            Icons.category,
            'Category List',
            Colors.grey,
            () => Get.toNamed('/category-list'),
          ),
          buildMenuItem(
            context,
            Icons.branding_watermark,
            'Brand List',
            Colors.grey,
            () => Get.toNamed('/brand-list'),
          ),
          buildMenuItem(
            context,
            Icons.production_quantity_limits,
            'Product List',
            Colors.grey,
            () => Get.toNamed('/product-list'),
          ),
          buildMenuItem(
            context,
            Icons.image,
            'Banner List',
            Colors.grey,
            () => Get.toNamed('/banner-list'),
          ),
          buildMenuItem(
            context,
            Icons.payment,
            'Payment List',
            Colors.grey,
            () => Get.toNamed('/payment-list'),
          ),
          buildMenuItem(
            context,
            Icons.category,
            'Privacy Policy',
            Colors.grey,
            () => Get.toNamed('/add-privacy'),
          ),
          buildMenuItem(
            context,
            Icons.payment,
            'Send Notification',
            Colors.grey,
            () => Get.toNamed('/send-notification'),
          ),
          const SizedBox(
            height: 16,
          ),
          buildMenuItem(
            context,
            Icons.logout,
            'Logout',
            Colors.grey,
            () => FirebaseAuth.instance.signOut(),
          ),
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
