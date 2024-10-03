class CartItem {
  final String productId;
  final String name;
  final int price;
  int quantity;
  final int size;
  final String color;
  final String imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.quantity,
    required this.size,
    required this.color,
    required this.imageUrl,
  });

  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'size': size,
      'color': color,
      'quantity': quantity,
    };
  }

  // Create CartItem from JSON
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['productId'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      size: json['size'],
      color: json['color'],
      quantity: json['quantity'],
    );
  }
}
