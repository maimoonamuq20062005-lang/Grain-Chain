import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'models/food_item.dart';
import '../utils/responsive.dart';
import '../services/user_session_service.dart';

class FoodPostPage extends StatefulWidget {
  final Function(FoodItem) onAddFood;

  const FoodPostPage({super.key, required this.onAddFood});

  @override
  State<FoodPostPage> createState() => _FoodPostPageState();
}

class _FoodPostPageState extends State<FoodPostPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _ingredientsController = TextEditingController();
  final TextEditingController _nutritionController = TextEditingController();
  final UserSessionService _userSessionService = UserSessionService();

  File? _selectedImage;
  String? _imageBase64;
  final ImagePicker _imagePicker = ImagePicker();

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: const BorderSide(color: Color(0xFFE91E63)),
      ),
    );
  }

  /// Pick image from device
  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85, // Compress image to 85% quality
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
        });

        // Convert to base64
        final bytes = await _selectedImage!.readAsBytes();
        _imageBase64 = base64Encode(bytes);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Image selected successfully")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error picking image: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Post Food"),
        backgroundColor: const Color(0xFFE91E63),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("Food Name"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter food name" : null,
                ),
                SizedBox(height: SizeConfig.hp(1.8)),
                TextFormField(
                  controller: _descController,
                  decoration: _inputDecoration("Description"),
                  maxLines: 2,
                  validator: (value) =>
                      value!.isEmpty ? "Enter description" : null,
                ),
                SizedBox(height: SizeConfig.hp(1.8)),
                TextFormField(
                  controller: _expiryController,
                  decoration: _inputDecoration("Expiry Date"),
                  validator: (value) =>
                      value!.isEmpty ? "Enter expiry date" : null,
                ),
                SizedBox(height: SizeConfig.hp(1.8)),
                // Image Picker Section
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    children: [
                      // Show selected image or placeholder
                      Container(
                        height: 150,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                        ),
                        child: _selectedImage != null
                            ? Image.file(_selectedImage!, fit: BoxFit.cover)
                            : Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                      ),
                      // Pick image button
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _pickImage,
                            icon: const Icon(Icons.camera_alt),
                            label: Text(
                              _selectedImage != null
                                  ? "Change Image"
                                  : "Pick Image from Device",
                              style: TextStyle(fontSize: SizeConfig.sp(14)),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE91E63),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: SizeConfig.hp(1.8)),
                TextFormField(
                  controller: _ingredientsController,
                  decoration: _inputDecoration("Ingredients"),
                  maxLines: 2,
                ),
                SizedBox(height: SizeConfig.hp(1.8)),
                TextFormField(
                  controller: _nutritionController,
                  decoration: _inputDecoration("Nutrition"),
                  maxLines: 2,
                ),
                SizedBox(height: SizeConfig.hp(3)),
                SizedBox(
                  width: double.infinity,
                  height: SizeConfig.hp(6.5),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // Get the real logged-in user from UserSessionService
                        final loggedInUser = _userSessionService
                            .getCurrentUser();

                        if (loggedInUser == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Please login first")),
                          );
                          return;
                        }

                        widget.onAddFood(
                          FoodItem(
                            id: DateTime.now().toString(),
                            name: _nameController.text,
                            description: _descController.text,
                            imageUrl:
                                _imageBase64 ??
                                "icon", // Use base64 or fallback to icon
                            expiry: _expiryController.text,
                            ingredients: _ingredientsController.text,
                            nutrition: _nutritionController.text,
                            owner: loggedInUser, // Use real logged-in user
                          ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Post Food",
                      style: TextStyle(
                        fontSize: SizeConfig.sp(16),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: SizeConfig.hp(2.5)),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.grey[100],
    );
  }
}
