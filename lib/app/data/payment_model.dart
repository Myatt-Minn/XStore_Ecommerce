class PaymentModel {
  String id;
  String imgUrl;
  String name;
  String phone;
  String title;

  PaymentModel({
    required this.id,
    required this.imgUrl,
    required this.name,
    required this.phone,
    required this.title,
  });

  // Factory method to create an instance from Firestore document snapshot
  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'],
      imgUrl: json['imgUrl'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      title: json['title'] ?? '',
    );
  }

  // Method to convert an instance to a Map for saving into Firestore
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imgUrl': imgUrl,
      'name': name,
      'phone': phone,
      'title': title,
    };
  }
}
