import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/user_session_service.dart';

class HomeProfilePage extends StatelessWidget {
  final UserSessionService _userSessionService = UserSessionService();

  HomeProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    // Get current logged-in user from session
    final currentUser = _userSessionService.getCurrentUser();
    final userEmail =
        _userSessionService.getCurrentUserEmail() ??
        FirebaseAuth.instance.currentUser?.email ??
        'Not set';

    if (currentUser == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 80, color: Colors.red),
            const SizedBox(height: 20),
            const Text("User session not found. Please login again."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text("Go to Login"),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Profile Avatar with Icon instead of image
          CircleAvatar(
            radius: SizeConfig.wp(14),
            backgroundColor: Colors.pink.shade100,
            child: Icon(
              Icons.person,
              size: SizeConfig.wp(14),
              color: Colors.white,
            ),
          ),
          SizedBox(height: SizeConfig.hp(1.5)),
          Text(
            currentUser.name,
            style: TextStyle(
              fontSize: SizeConfig.sp(22),
              fontWeight: FontWeight.bold,
              color: const Color(0xFFE91E63),
            ),
          ),
          SizedBox(height: SizeConfig.hp(0.8)),
          Text(
            "User ID: ${currentUser.id}",
            style: const TextStyle(color: Colors.grey),
          ),
          SizedBox(height: SizeConfig.hp(3)),

          // Card for user details
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 12,
                  spreadRadius: 2,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email, color: Color(0xFFE91E63)),
                  title: const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(userEmail),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person, color: Color(0xFFE91E63)),
                  title: const Text(
                    "Username",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(currentUser.name),
                ),
              ],
            ),
          ),
          SizedBox(height: SizeConfig.hp(3)),

          SizedBox(
            width: double.infinity,
            height: SizeConfig.hp(6),
            child: ElevatedButton.icon(
              onPressed: () async {
                // 1. Sign out from Firebase
                await FirebaseAuth.instance.signOut();

                // 2. Clear user session
                await _userSessionService.clearUserSession();

                // 3. Clear login state in SharedPreferences
                final prefs = await SharedPreferences.getInstance();
                await prefs.remove('isLoggedIn');
                await prefs.setBool('onboardingSeen', false);

                // 4. Navigate to login
                Navigator.pushReplacementNamed(context, '/login');
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
