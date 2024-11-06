import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/consts_config.dart';
import 'package:xstore/app/modules/product_list/controllers/product_list_controller.dart';

class AddProductView extends GetView<ProductListController> {
  const AddProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Product',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: ConstsConfig.primarycolor,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: controller.formKey, // Add form validation key
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Input field for product name
                TextFormField(
                  onChanged: (value) => controller.productName.value = value,
                  decoration: const InputDecoration(
                    labelText: 'Product Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a product name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Input field for description
                TextFormField(
                  onChanged: (value) => controller.description.value = value,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dropdown for Category
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.selectedCategory.value.isNotEmpty
                        ? controller.selectedCategory.value
                        : null,
                    hint: const Text('Select Category'),
                    items: controller.categories.map((category) {
                      return DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedCategory.value = value!;
                    },
                    isExpanded: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a category';
                      }
                      return null;
                    },
                  );
                }),

                const SizedBox(height: 16),

                // Dropdown for Brand
                Obx(() {
                  return DropdownButtonFormField<String>(
                    value: controller.selectedBrand.value.isNotEmpty
                        ? controller.selectedBrand.value
                        : null,
                    hint: const Text('Select Brand'),
                    items: controller.brands.map((brand) {
                      return DropdownMenuItem<String>(
                        value: brand,
                        child: Text(brand),
                      );
                    }).toList(),
                    onChanged: (value) {
                      controller.selectedBrand.value = value!;
                    },
                    isExpanded: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a brand';
                      }
                      return null;
                    },
                  );
                }),
                const SizedBox(height: 16),
                Obx(() => CheckboxListTile(
                      title: const Text("Popular"),
                      value: controller.isPopular.value,
                      onChanged: (bool? newValue) {
                        controller.isPopular.value = newValue!;
                      },
                    )),
                // Input fields for size, price, and quantity (No validation here)
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: controller.sizeController,
                        decoration: const InputDecoration(
                          labelText: 'Size',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controller.priceController,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextFormField(
                        controller: controller.quantityController,
                        decoration: const InputDecoration(
                          labelText: 'Quantity',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Button to add size to the list
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.validateSizeFields()) {
                        controller.addSize(
                          int.parse(controller.sizeController.text.trim()),
                          int.parse(controller.priceController.text.trim()),
                          int.parse(controller.quantityController.text.trim()),
                        );

                        controller.clearSizeFields(); // Clear after adding
                      }
                    },
                    child: const Text('Add Size'),
                  ),
                ),

                const SizedBox(height: 16),

                // Display the list of added sizes
                Obx(() => ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.sizes.length,
                      itemBuilder: (context, index) {
                        final sizeData = controller.sizes[index];
                        return ListTile(
                          title: Text(
                            'Size: ${sizeData['size']}, Price: ${sizeData['price']}, Quantity: ${sizeData['quantity']}',
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              controller.sizes.removeAt(index);
                            },
                          ),
                        );
                      },
                    )),

                const SizedBox(height: 16),

                // Button to add images
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await controller.pickImages();
                    },
                    icon: const Icon(Icons.add_a_photo),
                    label: const Text('Add Images'),
                  ),
                ),

                const SizedBox(height: 8),

                // Display selected images
                Obx(() => controller.images.isNotEmpty
                    ? Wrap(
                        spacing: 10,
                        children: controller.images
                            .map(
                              (image) => Stack(
                                children: [
                                  Image.file(
                                    File(image.path),
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        controller.images.remove(image);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                      )
                    : const Text('No images selected')),
                const SizedBox(height: 16),

                // Button to add product to Firestore with new validation
                Center(
                  child: ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          // Additional validation for sizes and images
                          if (controller.sizes.isEmpty) {
                            Get.snackbar(
                                'Error', 'Please add at least one size.',
                                backgroundColor: Colors.red);
                            return;
                          }
                          if (controller.images.isEmpty) {
                            Get.snackbar(
                                'Error', 'Please add at least one image.',
                                backgroundColor: Colors.red);
                            return;
                          }
                          controller.addProductToFirestore();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ConstsConfig.secondarycolor,
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                      ),
                      child: Obx(
                        () => controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text(
                                'Add Product',
                                style: TextStyle(color: Colors.white),
                              ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
