import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/modules/product_list/controllers/product_list_controller.dart';

class EditProductView extends GetView<ProductListController> {
  final String productId = Get.arguments; // The ID of the product to edit

  EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Product'),
        backgroundColor: const Color(0xFF2E394D),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: controller.loadSpecificProduct(productId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: controller.formKey, // Form validation key
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Input field for product name
                    TextFormField(
                      controller: controller.productNameController,
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
                      controller: controller.descriptionController,
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
                      return DropdownButton<String>(
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
                      );
                    }),

                    const SizedBox(height: 16),

                    // Dropdown for Brand
                    Obx(() {
                      return DropdownButton<String>(
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
                      );
                    }),
                    const SizedBox(height: 16),

                    // Input fields for size, price, and quantity
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

                    // Button to update size
                    Obx(
                      () => ElevatedButton(
                        onPressed: () {
                          if (controller.isEditingSize.value) {
                            controller.updateSize(
                              int.parse(controller.sizeController.text.trim()),
                              int.parse(controller.priceController.text.trim()),
                              int.parse(
                                  controller.quantityController.text.trim()),
                            );
                          } else {
                            controller.addSize(
                              int.parse(controller.sizeController.text.trim()),
                              int.parse(controller.priceController.text.trim()),
                              int.parse(
                                  controller.quantityController.text.trim()),
                            );
                          }
                        },
                        child: Text(controller.isEditingSize.value
                            ? 'Update Size'
                            : 'Add Size'),
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
                            return GestureDetector(
                              onTap: () {
                                controller.setSizeForEditing(index);
                              },
                              child: ListTile(
                                title: Text(
                                    'Size: ${sizeData['size']}, Price: ${sizeData['price']}, Quantity: ${sizeData['quantity']}'),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    controller.deleteSize(index);
                                  },
                                ),
                              ),
                            );
                          },
                        )),
                    const SizedBox(height: 16),

                    // Button to pick images
                    ElevatedButton.icon(
                      onPressed: () async {
                        await controller.pickImages();
                      },
                      icon: const Icon(Icons.add_a_photo),
                      label: const Text('Add Images'),
                    ),
                    const SizedBox(height: 8),

                    // Display selected images
                    Obx(() => Wrap(
                          spacing: 10,
                          children: [
                            ...controller.imageUrls.map(
                              (url) => Stack(
                                children: [
                                  FancyShimmerImage(
                                    imageUrl: url,
                                    width: 100,
                                    height: 100,
                                    boxFit: BoxFit.cover,
                                    errorWidget: const Icon(Icons.error),
                                  ),
                                  Positioned(
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.cancel,
                                        color: Colors.red,
                                      ),
                                      onPressed: () {
                                        controller.deleteImage(url);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ...controller.images.map(
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
                            ),
                          ],
                        )),

                    const SizedBox(height: 16),

                    // Button to update product in Firestore
                    ElevatedButton(
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.updateProductInFirestore(productId);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2E394D),
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                          horizontal: 32.0,
                        ),
                      ),
                      child: const Text('Update Product'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
