import 'package:flutter/material.dart';
import 'food_post_page.dart';
import 'food_grid_item_fixed.dart';
import 'models/food_item.dart';
import '../utils/responsive.dart';
import '../services/data_service.dart';

class FoodHomePage extends StatefulWidget {
  const FoodHomePage({super.key});

  @override
  State<FoodHomePage> createState() => _FoodHomePageState();
}

class _FoodHomePageState extends State<FoodHomePage> {
  List<FoodItem> foodItems = [];
  final DataService _dataService = DataService();

  @override
  void initState() {
    super.initState();
    _loadFoodItems();
  }

  void _loadFoodItems() {
    // Load from local storage
    final savedItems = _dataService.loadFoodItems();

    setState(() {
      // Use only saved items (no dummy data fallback)
      foodItems = savedItems;
    });
  }

  void _addFood(FoodItem item) {
    setState(() {
      foodItems.add(item);
    });
    // Save to persistent storage
    _dataService.saveFoodItems(foodItems);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final screenW = SizeConfig.screenWidth;
    final isTablet = screenW > 600;
    final crossAxis = screenW > 900 ? 3 : (isTablet ? 2 : 2);

    // Adaptive tile height: ensures content fits without overflow on any device
    // Phone: ~320px, Tablet: ~340px, wider screens: capped to avoid too much white space
    final baseTileHeight = isTablet ? 340.0 : 320.0;
    final tileHeight = baseTileHeight; // fixed for consistency across devices

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: foodItems.isEmpty
              ? Center(
                  child: Text(
                    "No food posts yet!",
                    style: TextStyle(
                      fontSize: SizeConfig.sp(18),
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxis,
                    mainAxisExtent: tileHeight,
                    crossAxisSpacing: SizeConfig.wp(3),
                    mainAxisSpacing: SizeConfig.wp(3),
                  ),
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    return FoodGridItemFixed(food: foodItems[index]);
                  },
                ),
        ),
        Positioned(
          bottom: SizeConfig.wp(5),
          right: SizeConfig.wp(5),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FoodPostPage(onAddFood: _addFood),
                ),
              );
            },
            backgroundColor: const Color(0xFFE91E63),
            elevation: 6,
            child: Icon(Icons.add, size: SizeConfig.wp(8)),
          ),
        ),
      ],
    );
  }
}
