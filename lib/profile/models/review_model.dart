class ReviewModel {
  final String id;
  final String userId; // Link to reviewer
  final String foodId; // Link to food post
  final String ownerId; // Link to owner/food poster
  final String reviewerName;
  final String reviewerImage;
  final String comment;
  final double rating;
  final DateTime timestamp;

  ReviewModel({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.ownerId,
    required this.reviewerName,
    required this.reviewerImage,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  // Convert to JSON for persistence
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'foodId': foodId,
      'ownerId': ownerId,
      'reviewerName': reviewerName,
      'reviewerImage': reviewerImage,
      'comment': comment,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  // Create from JSON
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      foodId: json['foodId'] as String,
      ownerId: json['ownerId'] as String,
      reviewerName: json['reviewerName'] as String,
      reviewerImage: json['reviewerImage'] as String,
      comment: json['comment'] as String,
      rating: (json['rating'] as num).toDouble(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
