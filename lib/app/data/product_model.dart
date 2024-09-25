// Mock Product class and data
class Product {
  final String name;
  final String brand;
  final String price;
  final String image;

  Product(
      {required this.name,
      required this.brand,
      required this.price,
      required this.image});
}

// Mock data for demonstration
final List<Product> popularShoes = [
  Product(
      name: 'Jordan 1 Retro Chris Paul PE',
      brand: 'Nike',
      price: '500,000',
      image:
          'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/popular_shoes%2Fshoe02.png?alt=media&token=dddb07de-df0d-4865-a610-0bbadba1da94'),
  Product(
      name: 'Jordan 1 Mid Gym Red Panda',
      brand: 'Nike',
      price: '500,000',
      image:
          'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/popular_shoes%2Fshoe03.png?alt=media&token=99675f9b-0da0-461a-a25d-0dcdd319c683'),
  Product(
      name: 'Jordan 1 Mid Black Chile Red White',
      brand: 'Nike',
      price: '500,000',
      image:
          'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/popular_shoes%2Fshoe07.png?alt=media&token=a98841b0-a7a4-4037-9088-94f6ac4b7812'),
];

final List<Product> newArrivals = [
  Product(
      name: 'Adidas Forum 84 Low ADV',
      brand: 'Adidas',
      price: '500,000',
      image:
          'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/new_arrivals%2Fshoe01.png?alt=media&token=c7f446a1-b0bc-42e9-90b5-bb249635ef35'),
  Product(
      name: 'Air Jordan 1 Retro High OG University Blue',
      brand: 'Nike',
      price: '500,000',
      image:
          'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/new_arrivals%2Fshoe04.png?alt=media&token=a8fee84a-c3d6-4492-a05e-cc4841ccde9f'),
  Product(
      name: 'Adidas Forum Low m&m collaboration',
      brand: 'Adidas',
      price: '500,000',
      image:
          'https://firebasestorage.googleapis.com/v0/b/xstore-faa86.appspot.com/o/new_arrivals%2Fshoe05.png?alt=media&token=15ac97ec-a1e1-410c-b407-6df261f4278f'),
];
