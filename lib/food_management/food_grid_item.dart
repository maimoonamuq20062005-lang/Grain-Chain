import 'package:flutter/material.dart';
import 'models/food_item.dart';
import 'food_detail_page.dart';
import 'owner_profile_page.dart';
import '../utils/responsive.dart';

class FoodGridItem extends StatelessWidget {
  final FoodItem food;

  const FoodGridItem({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 4,
      shadowColor: Colors.grey.shade300,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Food Icon instead of image
          Container(
            height: 65,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(15),
              ),
            ),
            child: Center(
              child: Icon(
                Icons.fastfood,
                size: 40,
                color: const Color(0xFFE91E63),
              ),
            ),
          ),
          SizedBox(height: 6),
          // Use Expanded so inner content fills available space and button stays visible
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    food.name,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Text(
                    'Expiry: ${food.expiry}',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 11),
                  ),
                  SizedBox(height: 4),
                  // Owner clickable with person icon
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
                          radius: SizeConfig.wp(3.5),
                          backgroundColor: const Color(0xFFE91E63),
                          child: Icon(
                            Icons.person,
                            size: SizeConfig.wp(4.5),
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: SizeConfig.wp(2)),
                        Flexible(
                          child: Text(
                            food.owner.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFE91E63),
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    height: 38,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FoodDetailPage(food: food),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(
                        "Details",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 6),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
