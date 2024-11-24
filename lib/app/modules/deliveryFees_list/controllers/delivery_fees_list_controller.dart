import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/deli_model.dart';

class DeliveryFeesListController extends GetxController {
  var isLoading = false.obs;
  var regions = <Region>[].obs;
  var titleController = TextEditingController();
  var index = 1;

  @override
  void onInit() {
    super.onInit();
    fetchRegions();
  }

  // Fetch regions from Firestore
  void fetchRegions() async {
    isLoading.value = true;
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection('regions').get();

      regions.value = snapshot.docs.map((doc) {
        return Region.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch regions: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a specific region
  Future<void> deleteRegion(String regionId) async {
    try {
      await FirebaseFirestore.instance
          .collection('regions')
          .doc(regionId)
          .delete();
      regions.removeWhere((region) => region.id == regionId);
      Get.snackbar('Success', 'Region deleted successfully.');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete region: $e');
    }
  }

  // Delete a specific city in a region
  Future<void> deleteCity(String regionId, String cityName) async {
    try {
      Region? region = regions.firstWhereOrNull((r) => r.id == regionId);
      if (region != null) {
        region.cities.removeWhere((city) => city.name == cityName);
        await FirebaseFirestore.instance
            .collection('regions')
            .doc(regionId)
            .update({
          'cities': region.cities.map((city) => city.toMap()).toList(),
        });
        regions.refresh();
        Get.snackbar('Success', 'City deleted successfully.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete city: $e');
    }
  }
}
