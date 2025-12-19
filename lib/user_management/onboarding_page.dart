import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../user_management/login.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  // Save that onboarding was seen
  Future<void> _setOnboardingSeen() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("onboardingSeen", true);
  }

  // Navigate to LoginPage
  void _goToLogin(BuildContext context) async {
    await _setOnboardingSeen();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE91E63),
      body: Stack(
        children: [
          // TOP DECOR CIRCLE
          Positioned(
            top: -SizeConfig.wp(12),
            left: -SizeConfig.wp(10),
            child: Container(
              height: SizeConfig.wp(40),
              width: SizeConfig.wp(40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // BOTTOM DECOR CIRCLE
          Positioned(
            bottom: -SizeConfig.wp(16),
            right: -SizeConfig.wp(12),
            child: Container(
              height: SizeConfig.wp(50),
              width: SizeConfig.wp(50),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                shape: BoxShape.circle,
              ),
            ),
          ),

          // MAIN CONTENT
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // SKIP BUTTON
                  Align(
                    alignment: Alignment.topRight,
                    child: TextButton(
                      onPressed: () => _goToLogin(context),
                      child: const Text(
                        "Skip",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.hp(6)),

                  // LOGO
                  Image.asset(
                    "assets/images/logo.png",
                    width: SizeConfig.wp(40),
                  ),

                  SizedBox(height: SizeConfig.hp(3.5)),

                  // HEADING
                  Text(
                    "Welcome to GrainChain",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.sp(28),
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1,
                    ),
                  ),

                  SizedBox(height: SizeConfig.hp(2.5)),

                  // DESCRIPTION
                  Text(
                    "Share extra food, reduce waste,\nand help people around you.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: SizeConfig.sp(17),
                      color: Colors.white70,
                      height: 1.5,
                    ),
                  ),

                  const Spacer(),

                  // GET STARTED BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _goToLogin(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 40,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFFE91E63),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: SizeConfig.hp(6)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
