import 'package:flutter/material.dart';

class OrderRow extends StatelessWidget {
  final int index;
  final String customerName;
  final String paymentStatus;

  const OrderRow({
    Key? key,
    required this.index,
    required this.customerName,
    required this.paymentStatus,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: index % 2 == 0 ? Colors.grey[100] : Colors.grey[200],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            (index + 1).toString(),
            style: const TextStyle(color: Colors.black),
          ),
          Text(customerName, style: const TextStyle(color: Colors.black)),
          Text(paymentStatus, style: const TextStyle(color: Colors.black)),
        ],
      ),
    );
  }
}
