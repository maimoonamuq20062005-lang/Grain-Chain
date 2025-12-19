import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../utils/responsive.dart';
import '../services/user_session_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _loading = false;
  final UserSessionService _userSessionService = UserSessionService();

  Future<void> _signup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _loading = true);

    try {
      // Create Firebase user
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Generate unique user ID from username and email
      final userId = UserSessionService.generateUserId(
        _usernameController.text.trim(),
        _emailController.text.trim(),
      );

      // Save user session with username
      await _userSessionService.saveUserSession(
        userId: userId,
        userName: _usernameController.text.trim(),
        userEmail: _emailController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Welcome ${_usernameController.text.trim()}! Account created.',
          ),
        ),
      );

      // Move user to home screen
      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message ?? "Signup failed")));
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
                      Icons.person_add,
                      size: 40,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(2.7)),

                  Text(
                    "Create Account",
                    style: TextStyle(
                      fontSize: SizeConfig.sp(28),
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFFE91E63),
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(1.5)),
                  Text(
                    "Sign up to get started",
                    style: TextStyle(
                      fontSize: SizeConfig.sp(16),
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(3)),

                  // Username field
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
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
                      prefixIcon: const Icon(Icons.person),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 15,
                      ),
                    ),
                    validator: (value) =>
                        value!.isEmpty ? "Enter username" : null,
                  ),
                  SizedBox(height: SizeConfig.hp(2.5)),

                  // Email field
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
                    validator: (value) => value!.isEmpty ? "Enter email" : null,
                  ),
                  SizedBox(height: SizeConfig.hp(2.5)),

                  // Password field
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
                    validator: (value) =>
                        value!.length < 6 ? "Minimum 6 characters" : null,
                  ),
                  SizedBox(height: SizeConfig.hp(3.5)),

                  // Signup button
                  SizedBox(
                    width: double.infinity,
                    height: SizeConfig.hp(6.5),
                    child: ElevatedButton(
                      onPressed: _loading ? null : _signup,
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
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: SizeConfig.hp(1.8)),

                  // Navigate to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already have an account?",
                        style: TextStyle(color: Colors.grey),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: const Text(
                          "Login",
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
