import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/check_out/controllers/check_out_controller.dart';
import 'package:xstore/app/modules/check_out/views/widgets/customtextfield.dart';

class AddressSection extends GetView<CheckOutController> {
  const AddressSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Address",
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          const SizedBox(height: 8),
          // Region Dropdown
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.selectedRegion.value.isEmpty
                    ? null
                    : controller.selectedRegion.value,
                hint: const Text("Select Region"),
                items: controller.regions.map((region) {
                  return DropdownMenuItem<String>(
                    value: region,
                    child: Text(region),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.onRegionSelected(value!);
                },
              ),
            );
          }),
          const SizedBox(height: 8),
          // City Dropdown
          Obx(() {
            return SizedBox(
              width: double.infinity,
              child: DropdownButton<String>(
                isExpanded: true,
                value: controller.selectedCity.value.isEmpty
                    ? null
                    : controller.selectedCity.value,
                hint: const Text("Select City"),
                items: controller.cities.map((city) {
                  return DropdownMenuItem<String>(
                    value: city['name'],
                    child: Text(city['name']),
                  );
                }).toList(),
                onChanged: (value) {
                  controller.onCitySelected(value!);
                },
              ),
            );
          }),
          const SizedBox(height: 8),
          // Address Detail Text Field
          CustomTextField(
            controller: controller.addressController,
            icon: Icons.home_outlined,
            hintText: 'Address Detail',
          ),
        ],
      ),
    );
  }
}
