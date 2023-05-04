import 'package:flutter/material.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  void _saveProfile() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              'Salva',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 12),
            Text('Full Name', style: TextStyle(fontSize: 18)),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'Your Name',
              ),
            ),
            SizedBox(height: 16),
            Text('Email', style: TextStyle(fontSize: 18)),
            TextField(
              enabled: false,
              decoration: InputDecoration(
                hintText: 'email@example.com',
              ),
            ),
            SizedBox(height: 16),
            Text('Phone Number', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                hintText: '+1 123 456 7890',
              ),
            ),
            SizedBox(height: 16),
            Text('Address', style: TextStyle(fontSize: 18)),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: '123 Main St',
              ),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }
}
