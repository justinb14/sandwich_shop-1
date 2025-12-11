// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:sandwich_shop/views/app_styles.dart';
// ignore: duplicate_ignore
// ignore: unused_import
import 'package:provider/provider.dart';
import 'package:sandwich_shop/models/cart.dart';
import 'package:sandwich_shop/views/common_widgets.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    final String name = _nameController.text.trim();
    final String location = _locationController.text.trim();

    final bool nameIsNotEmpty = name.isNotEmpty;
    final bool locationIsNotEmpty = location.isNotEmpty;
    final bool bothFieldsFilled = nameIsNotEmpty && locationIsNotEmpty;

    if (bothFieldsFilled) {
      _returnProfileData(name, location);
    } else {
      _showValidationError();
    }
  }

  void _returnProfileData(String name, String location) {
    final Map<String, String> profileData = {
      'name': name,
      'location': location,
    };
    Navigator.pop(context, profileData);
  }

  void _showValidationError() {
    const SnackBar validationSnackBar = SnackBar(
      content: Text('Please fill in all fields'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(validationSnackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: 'Profile'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Enter your details:', style: heading2),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Preferred Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Save Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
