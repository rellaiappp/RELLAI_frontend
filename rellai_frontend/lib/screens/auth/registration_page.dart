import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rellai_frontend/services/auth.dart';
import 'package:rellai_frontend/services/show_dialog.dart';

// Import your LoginScreen widget
import 'login_page.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  bool _isLoading = false;
  String _accountType = 'homeowner';
  List<bool> _selections = [true, false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Registration Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: SizedBox(
                height: 48.0,
                child: ToggleButtons(
                  onPressed: (int index) {
                    setState(() {
                      _selections = List.generate(2, (_) => false);
                      _selections[index] = true;
                      _accountType = index == 0 ? 'homeowner' : 'professional';
                    });
                  },
                  isSelected: _selections,
                  borderRadius: BorderRadius.circular(24.0),
                  color: Colors.grey,
                  selectedColor: Theme.of(context).primaryColor,
                  selectedBorderColor: Theme.of(context).primaryColor,
                  borderColor: Colors.grey,
                  borderWidth: 1.0,
                  constraints: const BoxConstraints.expand(width: 150.0),
                  children: const [
                    Text('Homeowner'),
                    Text('Professional'),
                  ],
                ),
              ),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome completo',
              ),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
              ),
            ),
            TextField(
              controller: _confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm Password',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _isLoading ? null : _register,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> createUserDB(
      String fuid, String mail, String role, String name) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse(
        '$baseUrl/api/v1/users/register'); // Replace with your endpoint URL
    final headers = {'Content-Type': 'application/json'};
    final body =
        jsonEncode({'uid': fuid, 'role': role, 'mail': mail, 'name': name});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final success = responseData['success'] as bool;
      return success;
    } else {
      throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }

  void _register() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Passwords do not match.")));
      return;
    }

    if (!EmailValidator.validate(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid email address.")));
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);
      // Show success  popup
      User user = userCredential.user!;
      user.sendEmailVerification();
      AuthService()
          .createUserDB(await userCredential.user!.getIdToken(),
              _emailController.text, _accountType, _nameController.text)
          .then((success) {
        if (success) {
        } else {}
      }).catchError((error) {
        print('Error: $error');
      });
      showCustomDialog(
        _scaffoldKey.currentContext!,
        "Registrazione avvenuta con successo",
        "Conferma la tua mail per poter accedere al servizio",
        Icons.verified_user,
        "Accedi",
        () {
          FirebaseAuth.instance.currentUser?.sendEmailVerification();
          Navigator.of(context).pop();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again later.';

      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
