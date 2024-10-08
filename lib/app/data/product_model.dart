class Product {
  String? id;
  String? name;
  int? price;
  String? description;
  List<String>? images;
  List<int>? sizes;
  List<String>? colors;
  String? brand;

  Product(
      {this.id,
      this.name,
      this.price,
      this.description,
      this.images,
      this.brand,
      this.sizes,
      this.colors});
  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'description': description,
      'image': images,
      'brand': brand,
      'sizes': sizes,
    };
  }

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    description = json['description'];

    // Handling lists correctly
    images = List<String>.from(
        json['image']); // Ensure image is treated as List<String>
    brand = json['brand'];
    sizes =
        List<int>.from(json['sizes']); // Ensure sizes is treated as List<int>
    colors = List<String>.from(
        json['colors']); // Ensure colors is treated as List<String>
  }
  static List<Product> productsfromSnapshot(List snapshot) {
    return snapshot.map((data) {
      return Product.fromJson(data);
    }).toList();
  }
}
