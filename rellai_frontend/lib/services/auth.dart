import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  void userLogIn(
      String email,
      String password,
      Function onStart,
      Function onAuthentication,
      Function onNotVerified,
      Function onError,
      Function onComplete) async {
    onStart();

    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!userCredential.user!.emailVerified) {
        onNotVerified();
      } else {
        onAuthentication();
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again later.';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      }
      onError(message);
    } finally {
      onComplete();
    }
  }

  Future<bool> registerUserOnDB(String token, String email, String role) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse('$baseUrl/api/v1/users/register');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'uid': token, 'role': role, 'mail': email});

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final success = responseData['success'] as bool;
      return success;
    } else {
      throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }

  void userRegister(
      String role,
      String email,
      String password,
      Function onStart,
      Function onRegistration,
      Function onFirebaseError,
      Function onServerError,
      Function onComplete) async {
    onStart();

    try {
      onStart();
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      registerUserOnDB(await userCredential.user!.getIdToken(), email, role)
          .then((success) {
        if (success) {
          onRegistration();
        } else {
          onServerError;
        }
      }).catchError((error) {
        onFirebaseError(error);
      });
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred. Please try again later.';

      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      }
      onFirebaseError(message);
    } finally {
      onComplete();
    }
  }

  Future<String?> getJwt() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      String idToken = await user.getIdToken();
      return idToken;
    } else {
      return null;
    }
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
}
