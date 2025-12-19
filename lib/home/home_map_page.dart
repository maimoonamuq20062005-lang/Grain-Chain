import 'package:flutter/material.dart';
import '../utils/responsive.dart';

class HomeMapPage extends StatelessWidget {
  const HomeMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Center(
      child: Text(
        "Map Module Page",
        style: TextStyle(
          fontSize: SizeConfig.sp(24),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
