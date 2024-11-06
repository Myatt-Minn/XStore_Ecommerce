import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/app_widgets.dart';
import 'package:xstore/app/data/content_model.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // PageView for onboarding content
          Expanded(
            child: PageView.builder(
              controller: controller.pageController,
              itemCount: contents.length,
              onPageChanged: controller.changePage,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[index].image,
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      const SizedBox(height: 40.0),
                      Text(
                        contents[index].title,
                        style: AppWidgets.headlineTextFieldStyle(),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        contents[index].descritpion,
                        style: AppWidgets.lightTextFieldStyle(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Dots Indicator
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  contents.length,
                  (index) => buildDot(index, controller.currentPage.value),
                ),
              )),

          // Next or Start Button
          GestureDetector(
            onTap: controller.handleNext,
            child: Obx(() => Container(
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: 60,
                  margin: const EdgeInsets.all(40),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      controller.currentPage.value == contents.length - 1
                          ? "Start"
                          : "Next",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }

  // Dot builder for the page indicator
  Widget buildDot(int index, int currentPage) {
    return Container(
      height: 10.0,
      width: currentPage == index ? 18 : 7,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
