import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_management/onboarding_page.dart';
import '../user_management/login.dart';
import '../utils/responsive.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Animation
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();

    // Navigate after animation
    Timer(const Duration(seconds: 3), () {
      _checkNavigation();
    });
  }

  Future<void> _checkNavigation() async {
    final prefs = await SharedPreferences.getInstance();
    bool onboardingSeen = prefs.getBool("onboardingSeen") ?? false;
    bool isLoggedIn = prefs.getBool("isLoggedIn") ?? false;

    if (!onboardingSeen) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OnboardingPage()),
      );
    } else if (!isLoggedIn) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63),
      body: Stack(
        children: [
          // Top decor circle
          Positioned(
            top: -SizeConfig.wp(12),
            left: -SizeConfig.wp(10),
            child: Container(
              height: SizeConfig.wp(60),
              width: SizeConfig.wp(60),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Bottom decor circle
          Positioned(
            bottom: -SizeConfig.wp(14),
            right: -SizeConfig.wp(10),
            child: Container(
              height: SizeConfig.wp(70),
              width: SizeConfig.wp(70),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // Logo fade
          Center(
            child: FadeTransition(
              opacity: _animation,
              child: Image.asset(
                "assets/images/logo.png",
                width: SizeConfig.wp(45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
