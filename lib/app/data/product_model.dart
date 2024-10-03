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

// Mock data for demonstration
final List<Product> popular = [
  Product(
      name: 'Jordan 1 Retro Chris Paul PE',
      brand: 'Nike',
      price: 500000,
      images: [
        'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/popular_shoes%2Fshoe02.png?alt=media&token=dddb07de-df0d-4865-a610-0bbadba1da94'
      ]),
  Product(
      name: 'Jordan 1 Mid Gym Red Panda',
      brand: 'Nike',
      price: 500000,
      images: [
        'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/popular_shoes%2Fshoe03.png?alt=media&token=99675f9b-0da0-461a-a25d-0dcdd319c683'
      ]),
  Product(
      name: 'Jordan 1 Mid Black Chile Red White',
      brand: 'Nike',
      price: 500000,
      images: [
        'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/popular_shoes%2Fshoe07.png?alt=media&token=a98841b0-a7a4-4037-9088-94f6ac4b7812'
      ]),
];
