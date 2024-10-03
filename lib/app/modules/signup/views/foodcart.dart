import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xstore/app/data/app_widgets.dart';

class FoodCard extends StatelessWidget {
  final String image;
  final String title;

  const FoodCard({
    super.key,
    required this.image,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 10,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 250,
        padding: const EdgeInsets.all(8),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              image,
              width: 250,
              height: 150,
              fit: BoxFit.fill,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            title,
            softWrap: true,
            overflow: TextOverflow.clip,
            style: AppWidgets.smallboldlineTextFieldStyle(),
          ),
          Text(
            "Fresh and Healthy",
            style: AppWidgets.lightTextFieldStyle(),
          ),
        ]),
      ),
    );
  }
}
