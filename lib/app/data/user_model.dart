class UserModel {
  String email;
  String name;
  String phoneNumber;
  String profilepic;
  String role;
  String uid;

  UserModel({
    required this.email,
    required this.name,
    required this.phoneNumber,
    required this.profilepic,
    required this.role,
    required this.uid,
  });

  // Convert Firestore document data to UserModel object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      profilepic: json['profilepic'] ?? '',
      role: json['role'] ?? '',
      uid: json['uid'] ?? '',
    );
  }

  // Convert UserModel object to JSON (for saving to Firestore)
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profilepic': profilepic,
      'role': role,
      'uid': uid,
    };
  }
}
