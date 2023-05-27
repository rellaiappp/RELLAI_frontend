import 'package:rellai_frontend/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserCRUD {
  String varurl = "https://rellai.uc.r.appspot.com";
  // String varurl = "http://10.0.2.2:8080 ";
  Future<void> createUser(AppUser user, String aToken) async {
    var baseUrl = varurl;
    String url = '$baseUrl/users'; // Inserisci qui l'URL del tuo server
    print({
      'Content-Type': 'application/json',
      'Authorization': 'bearer $aToken'
    });
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $aToken'
      },
      body: json.encode(user.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  Future<void> updateUser(AppUser user) async {
    var baseUrl = varurl;
    final url = Uri.parse('$baseUrl/users/'); // Replace with your API's URL
    final body = {
      "address": user.address,
      "phone": user.phone,
      "profileImageUrl": user.profileImageUrl,
      "businessInfo": user.businessInfo,
    };

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}',
      },
      body: json.encode(body),
    );

    if (response.statusCode == 200) {
      print('User updated successfully');
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  Future<void> getUser(String id) async {
    var baseUrl = varurl;

    final url = Uri.parse('$baseUrl/users/$id'); // Replace with your API's URL

    final response = await http.get(url);

    if (response.statusCode == 200) {
      var user = json.decode(response.body);
      print('User retrieved successfully: $user');
    } else {
      throw Exception('Failed to load user: ${response.body}');
    }
  }

  Future<AppUser?> getCurrentUser() async {
    try {
      var baseUrl = varurl;
      final url = Uri.parse('$baseUrl/users'); // Replace with your API's URL
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}',
      };
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        var user = AppUser.fromJson(json.decode(response.body));
        print('User retrieved successfully: $user');
        return user;
      } else {
        return null;
      }
    } catch (e, s) {
      print(e);
      print(s);
    }
    return null;
  }
}
