class UserModel {
  final String id;
  final String name;
  final String profileImage;

  UserModel({required this.id, required this.name, required this.profileImage});

  // Convert UserModel to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'profileImage': profileImage};
  }

  // Create UserModel from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      profileImage: json['profileImage'] as String,
    );
  }
}
