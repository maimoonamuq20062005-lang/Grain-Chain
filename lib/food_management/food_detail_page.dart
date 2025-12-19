import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'models/food_item.dart';
import 'owner_profile_page.dart';
import '../../notifications/notification_service.dart';
import '../notifications/models/notification_model.dart';
import '../utils/responsive.dart';

class FoodDetailPage extends StatelessWidget {
  final FoodItem food;

  const FoodDetailPage({required this.food, super.key});

  /// Build image widget - displays base64 image if available, else shows icon
  Widget _buildImageWidget() {
    if (food.imageUrl.isNotEmpty &&
        food.imageUrl != "icon" &&
        food.imageUrl.length > 50) {
      try {
        // Assume it's base64 encoded image
        final Uint8List imageBytes = base64Decode(food.imageUrl);
        return Image.memory(imageBytes, fit: BoxFit.cover);
      } catch (e) {
        // If decoding fails, show icon
        return Icon(
          Icons.fastfood,
          size: SizeConfig.wp(25),
          color: const Color(0xFFE91E63),
        );
      }
    }
    // Default icon if no image
    return Icon(
      Icons.fastfood,
      size: SizeConfig.wp(25),
      color: const Color(0xFFE91E63),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(food.name),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Food Image or Icon
            Container(
              height: SizeConfig.hp(25),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(15),
              ),
              child: _buildImageWidget(),
            ),
            SizedBox(height: SizeConfig.hp(2)),
            Text(
              food.name,
              style: TextStyle(
                fontSize: SizeConfig.sp(26),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: SizeConfig.hp(0.5)),
            Text(
              'Expiry: ${food.expiry}',
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: SizeConfig.sp(14),
              ),
            ),
            SizedBox(height: SizeConfig.hp(2)),
            Text(
              'Description:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.sp(16),
              ),
            ),
            Text(
              food.description,
              style: TextStyle(fontSize: SizeConfig.sp(14)),
            ),
            SizedBox(height: SizeConfig.hp(1.5)),
            Text(
              'Ingredients:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.sp(16),
              ),
            ),
            Text(
              food.ingredients,
              style: TextStyle(fontSize: SizeConfig.sp(14)),
            ),
            SizedBox(height: SizeConfig.hp(1.5)),
            Text(
              'Nutrition:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.sp(16),
              ),
            ),
            Text(food.nutrition, style: TextStyle(fontSize: SizeConfig.sp(14))),
            SizedBox(height: SizeConfig.hp(2.5)),
            // Owner section clickable with person icon
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OwnerProfilePage(owner: food.owner),
                  ),
                );
              },
              child: Row(
                children: [
                  CircleAvatar(
                    radius: SizeConfig.wp(5.5),
                    backgroundColor: const Color(0xFFE91E63),
                    child: Icon(
                      Icons.person,
                      size: SizeConfig.wp(7),
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(width: SizeConfig.wp(3)),
                  Text(
                    food.owner.name,
                    style: TextStyle(
                      fontSize: SizeConfig.sp(16),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE91E63),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: SizeConfig.hp(3)),
            SizedBox(
              width: double.infinity,
              height: SizeConfig.hp(6),
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Food claimed!")),
                  );

                  try {
                    final notifService = Provider.of<NotificationService>(
                      context,
                      listen: false,
                    );
                    print(
                      '[FoodDetailPage] Sending claim notification to owner: ${food.owner.id}',
                    );
                    notifService.addNotification(
                      AppNotification(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        title: "Food Claimed",
                        body: "Your food item '${food.name}' was claimed!",
                        recipientUserId:
                            food.owner.id, // Send to food owner only
                        timestamp: DateTime.now(),
                        read: false,
                      ),
                    );
                  } catch (e) {
                    debugPrint("Notification error: $e");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE91E63),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Claim Food",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
