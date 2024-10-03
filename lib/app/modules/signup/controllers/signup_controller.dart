import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:xstore/app/data/product_model.dart';

class SignupController extends GetxController {
  //TODO: Implement SignupController

  final count = 0.obs;
  Stream? foodcards;
  void increment() => count.value++;
  @override
  void onInit() async {
    super.onInit();
    await getFoodItems();
  }

  Future<void> getFoodItems() async {
    foodcards = FirebaseFirestore.instance.collection("Icecream").snapshots();
  }
}
