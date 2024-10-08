import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';
import 'package:xstore/app/modules/Cart/controllers/cart_controller.dart';
import 'package:xstore/app/modules/product_details/controllers/product_details_controller.dart';

class ProductDetailsView extends GetView<ProductDetailsController> {
  const ProductDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    Get.put(CartController());
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail'),
        actions: [
          // Cart icon with badge
          Obx(() => Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () {
                      // Navigate to Cart Page
                      Get.toNamed('/cart');
                    },
                  ),
                  if (cartController.itemCount >
                      0) // Show badge only if there are items
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 16,
                          minHeight: 16,
                        ),
                        child: Text(
                          '${cartController.itemCount}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              )),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Product Image
                    Obx(() => Center(
                          child: FancyShimmerImage(
                            imageUrl: controller.product
                                .images![controller.selectedImageIndex.value],
                            height: 180,
                            width: 250,
                            boxFit: BoxFit.contain,
                          ),
                        )),
                    const SizedBox(height: 10),
                    // Thumbnail Images (Carousel)
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.product.images!.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              controller.changeImage(index);
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Obx(() => Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: controller.selectedImageIndex
                                                      .value ==
                                                  index
                                              ? const Color(0xFF95CCA9)
                                              : Colors.transparent,
                                          width: 2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: FancyShimmerImage(
                                      imageUrl:
                                          controller.product.images![index],
                                      width: 70,
                                      height: 70,
                                      boxFit: BoxFit.contain,
                                    ),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(controller.product.name!,
                        style: AppWidgets.smallboldlineTextFieldStyle()),
                    const SizedBox(height: 5),
                    Text("${controller.product.price!} MMK",
                        style: AppWidgets.boldTextFieldStyle()),

                    const SizedBox(height: 10),
                    Text(controller.product.description!,
                        style: AppWidgets.lightTextFieldStyle()),
                    const SizedBox(height: 10),
                    // Size Selection
                    const Text("Size"),
                    Obx(() => Wrap(
                          children: List.generate(
                            controller.product.sizes!.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              child: ChoiceChip(
                                selectedColor: Colors.green[300],
                                label: Text(controller.product.sizes![index]
                                    .toString()),
                                selected:
                                    controller.selectedSize.value == index,
                                onSelected: (selected) {
                                  controller.changeSize(index);
                                },
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 10),
                    // Color Selection
                    const Text("Color"),
                    Obx(() => Wrap(
                          children: List.generate(
                            controller.product.colors!.length,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: ChoiceChip(
                                selectedColor: Colors.green[300],
                                label: Text(controller.product.colors![index]),
                                selected:
                                    controller.selectedColor.value == index,
                                onSelected: (selected) {
                                  controller.changeColor(index);
                                },
                              ),
                            ),
                          ),
                        )),
                    const SizedBox(height: 20),
                    // Add to Cart Button
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: controller.decreaseQuantity,
                        ),
                        Obx(() => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(color: Colors.green[300]),
                            child: Text(
                              controller.quantity.toString(),
                            ))),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: controller.increaseQuantity,
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors
                                  .green[300], // Set the background color here
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    12), // Optional: To match the design with rounded corners
                              ),
                            ),
                            onPressed: controller.addToCart,
                            child: const Text(
                              "Add To Cart",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
