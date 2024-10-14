class BrandModel {
  String id;
  String imgUrl;
  String title;

  BrandModel({
    required this.id,
    required this.imgUrl,
    required this.title,
  });

  // Convert BrandModel to JSON (Map<String, dynamic>)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'title': title,
    };
  }

  // Factory method to create a BrandModel from JSON
  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'],
      imgUrl: json['imgUrl'],
      title: json['title'],
    );
  }
}
