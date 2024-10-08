import 'package:xstore/app/data/cart_model.dart';

class OrderItem {
  final String? orderId;
  final String? userId;
  final String? name;
  final String? phoneNumber;
  final String? orderDate;
  final String? status;
  final String? transationUrl;
  final int? totalPrice;
  final List<CartItem>? items;
  final String? paymentMethod; // Payment method as a String
  final String? address;

  OrderItem(
      {this.name,
      this.phoneNumber,
      this.transationUrl,
      this.orderId,
      this.userId,
      this.orderDate,
      this.status,
      this.totalPrice,
      this.items,
      this.paymentMethod,
      this.address});

  // Convert Firestore data to Order model
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      orderId: map['orderId'] ?? '',
      userId: map['userId'] ?? '',
      name: map['name'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      orderDate: map['orderDate'] ?? '',
      transationUrl: map['transationUrl'] ?? '',
      status: map['status'] ?? 'Pending',
      totalPrice: (map['totalPrice'] ?? 0),
      items: (map['items'] as List<dynamic>)
          .map((item) => CartItem.fromJson(item))
          .toList(),
      paymentMethod: map['paymentMethod'] ?? '',
      address: map['address'] ?? '',
    );
  }

  // Convert Order model to Firestore compatible Map
  Map<String, dynamic> toMap() {
    return {
      'orderId': orderId,
      'userId': userId,
      'name': name,
      'phoneNumber': phoneNumber,
      'orderDate': orderDate,
      'status': status,
      'transationUrl': transationUrl,
      'totalPrice': totalPrice,
      'items': items!.map((item) => item.toJson()).toList(),
      'paymentMethod': paymentMethod,
      'address': address,
    };
  }
}
