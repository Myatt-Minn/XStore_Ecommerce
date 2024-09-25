class ContentModel {
  final String image;
  final String title;
  final String descritpion;

  ContentModel({
    required this.image,
    required this.title,
    required this.descritpion,
  });
}

final List<ContentModel> contents = [
  ContentModel(
    image: 'images/screen1.png',
    title: 'Welcome to Xstore',
    descritpion: 'Discover a variety of products at the best prices.',
  ),
  ContentModel(
    image: 'images/screen2.png',
    title: 'Easy Shopping',
    descritpion: 'Shop from anywhere at your convenience.',
  ),
  ContentModel(
    image: 'images/screen3.png',
    title: 'Fast Delivery',
    descritpion: 'Get your products delivered quickly and safely.',
  ),
];
