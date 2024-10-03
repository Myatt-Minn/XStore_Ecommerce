import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:xstore/app/modules/signup/views/foodcart.dart';

import '../controllers/signup_controller.dart';

class SignupView extends GetView<SignupController> {
  const SignupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SignupView'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: controller.foodcards,
            builder: (context, AsyncSnapshot snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: snapshot.data.docs.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                            snapshot.data.docs[index];

                        return GestureDetector(
                            onTap: () {},
                            child: FoodCard(
                              image: documentSnapshot['Image'],
                              title: documentSnapshot["Name"],
                            ));
                      })
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
