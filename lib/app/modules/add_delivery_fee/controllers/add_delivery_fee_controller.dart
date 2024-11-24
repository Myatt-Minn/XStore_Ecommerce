import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/deli_model.dart';

class AddDeliveryFeeController extends GetxController {
  final regionNameController = TextEditingController();
  final cityNameController = TextEditingController();
  final deliveryFeeController = TextEditingController();

  var cities = <City>[].obs; // Observable list of cities being added
  var isLoading = false.obs;

  // Add a new city to the list
  void addCity() {
    final cityName = cityNameController.text.trim();
    final deliveryFee = int.tryParse(deliveryFeeController.text.trim()) ?? 0;

    if (cityName.isEmpty || deliveryFee <= 0) {
      Get.snackbar('Error', 'City name and delivery fee are required.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    cities.add(City(name: cityName, deliveryFee: deliveryFee));
    cityNameController.clear();
    deliveryFeeController.clear();
  }

  // Remove a city from the list
  void removeCity(int index) {
    cities.removeAt(index);
  }

  // Save the region and cities to Firestore
  Future<void> saveRegion() async {
    final regionName = regionNameController.text.trim();

    if (regionName.isEmpty || cities.isEmpty) {
      Get.snackbar('Error', 'Region name and at least one city are required.',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      // Check if the region already exists
      final querySnapshot = await FirebaseFirestore.instance
          .collection('regions')
          .where('name', isEqualTo: regionName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        // Region exists, update its cities
        final regionDoc = querySnapshot.docs.first;
        final existingCities =
            List<Map<String, dynamic>>.from(regionDoc['cities']);

        // Avoid duplicate city names
        final newCities = cities.map((city) => city.toMap()).toList();
        final mergedCities = [
          ...existingCities,
          ...newCities.where((newCity) => !existingCities
              .any((existingCity) => existingCity['name'] == newCity['name']))
        ];

        // Update Firestore document
        await FirebaseFirestore.instance
            .collection('regions')
            .doc(regionDoc.id)
            .update({'cities': mergedCities});

        Get.snackbar('Success', 'Cities added to existing region!',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        // Region does not exist, create a new document
        final regionDoc =
            FirebaseFirestore.instance.collection('regions').doc(); // Auto ID
        final newRegion = Region(
          id: regionDoc.id,
          name: regionName,
          cities: cities,
        );

        await regionDoc.set(newRegion.toMap());
        Get.snackbar('Success', 'Region and cities added successfully!',
            backgroundColor: Colors.green, colorText: Colors.white);
      }

      // Clear the form
      regionNameController.clear();
      cities.clear();
    } catch (e) {
      Get.snackbar('Error', 'Failed to save region: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }
}
