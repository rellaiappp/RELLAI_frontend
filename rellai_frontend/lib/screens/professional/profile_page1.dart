import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rellai_frontend/services/api_service.dart';
import 'package:rellai_frontend/models/user_model.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AppUser? _user;

  @override
  void initState() {
    super.initState();
    ApiService().getUserInfo().then((value) {
      setState(() {
        _user = value;
      });
    });
  }

  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: _user == null
            ? CircularProgressIndicator() // visualizza indicatore di caricamento se l'utente non è ancora stato caricato
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Name: ${_user!.name}'), // mostra il nome dell'utente se l'utente è stato caricato
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _logout,
                    child: const Text('Logout'),
                  ),
                ],
              ),
      ),
    );
  }
}
