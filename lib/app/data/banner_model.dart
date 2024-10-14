class BannerModel {
  final String id;
  final String imgUrl;

  BannerModel({
    required this.id,
    required this.imgUrl,
  });

  // Create CartItem from JSON
  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      imgUrl: json['imgUrl'],
    );
  }
}
