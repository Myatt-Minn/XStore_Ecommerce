class Product {
  String? id;
  String? name;
  String? category;
  bool? popular;
  String? description;
  List<String>? images;
  List<Map<String, dynamic>>? sizes;
  String? brand;

  Product({
    this.id,
    this.name,
    this.category,
    this.popular,
    this.description,
    this.images,
    this.brand,
    this.sizes,
  });
  // Convert CartItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'image': images,
      'brand': brand,
      'popular': popular,
      'category': category,
      'sizes': sizes,
    };
  }

  // From JSON constructor
  factory Product.fromJson(Map<dynamic, dynamic> json) {
    return Product(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      category: json['category'] as String?,
      popular: json['popular'] as bool?,
      images: json['image'] != null ? List<String>.from(json['image']) : [],
      brand: json['brand'] as String?,
      sizes: json['sizes'] != null
          ? List<Map<String, dynamic>>.from(json['sizes'])
          : [],
    );
  }
}
