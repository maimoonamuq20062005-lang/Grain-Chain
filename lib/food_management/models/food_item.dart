import 'user_model.dart';

class FoodItem {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String expiry;
  final String ingredients;
  final String nutrition;
  final UserModel owner;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.expiry,
    required this.ingredients,
    required this.nutrition,
    required this.owner,
  });

  // Convert FoodItem to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'expiry': expiry,
      'ingredients': ingredients,
      'nutrition': nutrition,
      'owner': owner.toJson(),
    };
  }

  // Create FoodItem from JSON
  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      expiry: json['expiry'] as String,
      ingredients: json['ingredients'] as String,
      nutrition: json['nutrition'] as String,
      owner: UserModel.fromJson(json['owner'] as Map<String, dynamic>),
    );
  }
}
