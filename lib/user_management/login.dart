import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../utils/responsive.dart';
import '../services/user_session_service.dart';
import '../notifications/notification_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  final UserSessionService _userSessionService = UserSessionService();

  Future<void> _tryLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Check if user session exists in SharedPreferences
      final currentUser = _userSessionService.getCurrentUser();
      if (currentUser == null) {
        // User exists in Firebase but not in our session storage
        // This can happen if they signed up previously but data was cleared
        // Recreate session using email (derive username from email prefix)
        final email = _emailController.text.trim();
        final userNameFromEmail = email.split(
          '@',
        )[0]; // e.g., "hadia" from "hadia@test.com"

        // Generate consistent ID using email
        final userId = UserSessionService.generateUserId(
          userNameFromEmail,
          email,
        );

        // Save session so they're logged in
        await _userSessionService.saveUserSession(
          userId: userId,
          userName: userNameFromEmail,
          userEmail: email,
        );
      }

      // Save login state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isLoggedIn", true);

      // Reload notifications for the logged-in user
      try {
        final notifService = Provider.of<NotificationService>(
          context,
          listen: false,
        );
        notifService.reloadNotificationsForUser();
      } catch (e) {
        debugPrint("Error reloading notifications: $e");
      }

      // Navigate to home
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Login failed")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final screenW = SizeConfig.screenWidth;
    final double cardWidth = screenW > 420 ? 380 : screenW * 0.95;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Container(
            padding: const EdgeInsets.all(30),
            width: cardWidth,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade300,
                  blurRadius: 15,
                  spreadRadius: 5,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo placeholder
                  Container(
                    height: cardWidth * 0.21,
                    width: cardWidth * 0.21,
                    decoration: BoxDecoration(
                      color: Colors.pink.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.lock,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(2.7)),

                  Text(
                    "Welcome Back!",
                    style: TextStyle(
                      fontSize: SizeConfig.sp(28),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE91E63),
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(1.5)),
                  Text(
                    "Login to your account",
                    style: TextStyle(
                      fontSize: SizeConfig.sp(16),
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(3)),

                  // Email
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFFE91E63),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.email),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                    ),
                    validator: (value) =>
                        value == null || value.isEmpty ? "Enter email" : null,
                  ),
                  const SizedBox(height: 20),

                  // Password
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(
                          color: Color(0xFFE91E63),
                          width: 2,
                        ),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? "Enter password"
                        : null,
                  ),
                  SizedBox(height: SizeConfig.hp(3.5)),

                  // Login button
                  SizedBox(
                    width: double.infinity,
                    height: SizeConfig.hp(6.5),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _tryLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                      ),
                      child: _loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(1.8)),

                  // Navigate to signup
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: const Text(
                          "Sign Up",
                          style: TextStyle(
                            color: Color(0xFFE91E63),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
