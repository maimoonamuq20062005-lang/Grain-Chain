import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart'; // Provider import
import '../profile/models/review_model.dart';
import '../food_management/models/user_model.dart';
import '../../notifications/notification_service.dart';
import '../notifications/models/notification_model.dart';
import '../utils/responsive.dart';
import '../services/data_service.dart';

class OwnerProfilePage extends StatefulWidget {
  final UserModel owner;
  final String? foodId; // Optional: if viewing from food detail page

  const OwnerProfilePage({required this.owner, this.foodId, super.key});

  @override
  State<OwnerProfilePage> createState() => _OwnerProfilePageState();
}

class _OwnerProfilePageState extends State<OwnerProfilePage> {
  List<ReviewModel> reviews = [];
  final TextEditingController _reviewController = TextEditingController();
  double _rating = 5;
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  void _loadReviews() {
    // Load all reviews for this owner
    final ownerReviews = _dataService.getReviewsForOwner(widget.owner.id);
    setState(() {
      reviews = ownerReviews;
    });
  }

  void _addReview() {
    if (_reviewController.text.isEmpty) return;

    // Create new review with user ID linking
    final newReview = ReviewModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: "current_user_id", // In real app, get from auth
      foodId:
          widget.foodId ??
          "all_posts", // Link to specific food or all owner's posts
      ownerId: widget.owner.id, // Link to owner
      reviewerName: "You",
      reviewerImage: 'icon',
      comment: _reviewController.text,
      rating: _rating,
      timestamp: DateTime.now(),
    );

    // Save to persistent storage
    _dataService.addReview(newReview);

    setState(() {
      reviews.add(newReview);
    });

    // Notify the owner via NotificationService
    try {
      final notifService = Provider.of<NotificationService>(
        context,
        listen: false,
      );
      print(
        '[OwnerProfilePage] Sending notification to owner: ${widget.owner.id}',
      );
      notifService.addNotification(
        AppNotification(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: "New Review",
          body: "You received a new review: ${_reviewController.text}",
          recipientUserId: widget.owner.id, // Send to food owner only
          timestamp: DateTime.now(),
          read: false,
        ),
      );
    } catch (e) {
      debugPrint("Notification error: $e");
    }

    _reviewController.clear();
    _rating = 5;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Review added and saved!")));
  }

  void _deleteReview(String reviewId) {
    _dataService.deleteReview(reviewId);
    setState(() {
      reviews.removeWhere((r) => r.id == reviewId);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Review deleted")));
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.owner.name),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Owner Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: SizeConfig.wp(14),
                    backgroundColor: Colors.pink.shade100,
                    child: Icon(
                      Icons.person,
                      size: SizeConfig.wp(12),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(1.5)),
                  Text(
                    widget.owner.name,
                    style: TextStyle(
                      fontSize: SizeConfig.sp(24),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE91E63),
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(0.75)),
                  Text(
                    "User ID: ${widget.owner.id}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.hp(3)),
            const Divider(thickness: 1),
            SizedBox(height: SizeConfig.hp(1.8)),

            // Reviews Section
            Text(
              "Reviews",
              style: TextStyle(
                fontSize: SizeConfig.sp(18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: SizeConfig.hp(1.5)),

            ...reviews.map(
              (r) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  leading: const CircleAvatar(
                    backgroundColor: Colors.pink,
                    child: Icon(Icons.person, color: Colors.white),
                  ),
                  title: Text(
                    r.reviewerName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      RatingBarIndicator(
                        rating: r.rating,
                        itemBuilder: (context, _) =>
                            const Icon(Icons.star, color: Colors.amber),
                        itemCount: 5,
                        itemSize: 16,
                      ),
                      const SizedBox(height: 6),
                      Text(r.comment),
                      const SizedBox(height: 4),
                      Text(
                        'Posted: ${r.timestamp.toString().substring(0, 10)}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  trailing: r.reviewerName == "You"
                      ? IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteReview(r.id),
                        )
                      : null,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.hp(3)),

            // Add Review Section
            Text(
              "Add a Review",
              style: TextStyle(
                fontSize: SizeConfig.sp(18),
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE91E63),
              ),
            ),
            SizedBox(height: SizeConfig.hp(1.5)),
            RatingBar.builder(
              initialRating: _rating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {
                _rating = rating;
              },
            ),
            SizedBox(height: SizeConfig.hp(1.5)),
            TextField(
              controller: _reviewController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Write your review",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send, color: Color(0xFFE91E63)),
                  onPressed: _addReview,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.hp(2.5)),
          ],
        ),
      ),
    );
  }
}
