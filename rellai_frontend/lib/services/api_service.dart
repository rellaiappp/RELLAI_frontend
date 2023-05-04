import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/project.dart';
import '../models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  Future<String> getAccessToken() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      User user = auth.currentUser!;
      String accessToken = await user.getIdToken();
      return accessToken;
    } catch (e) {
      throw Exception('Failed to get access token: $e');
    }
  }

  Future<List<Project>> fetchProjects() async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    String userToken = await getAccessToken();
    final response = await http
        .get(Uri.parse('$baseUrl/api/v1/projects/data?auth_token=$userToken'));
    print(response.body);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final projectsJson = data['projects'] as List<dynamic>;
      final projects = projectsJson
          .map((projectJson) => Project.fromJson(projectJson))
          .toList();
      return projects;
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<bool> createProject(
      Map<String, dynamic> site, Map<String, dynamic> homeowner) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse(
        '$baseUrl/api/v1/projects/create'); // Replace with your endpoint URL
    final FirebaseAuth auth = FirebaseAuth.instance;
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer ${await auth.currentUser!.getIdToken()}'
    };
    final body = jsonEncode({
      'creator_id': auth.currentUser!.uid,
      'status': 'created',
      'general_info': site,
      'client_info': homeowner,
      'client_mail': homeowner['email'],
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }

  Future<bool> inviteUser(Map<String, dynamic> invite) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse(
        '$baseUrl/api/v1/projects/invite'); // Replace with your endpoint URL
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'creator_id': (await AuthService().getJwt())!,
      'status': 'created',
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }

  Future<AppUser> getUserInfo() async {
    await dotenv.load();
    final FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser!.uid;
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    String userToken = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $userToken'
    };
    final response = await http
        .get(Uri.parse('$baseUrl/api/v1/users/data?id=$id'), headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final userJson = data['user'] as Map<String, dynamic>;
      final user = AppUser.fromJson(userJson);
      return user;
    } else {
      throw Exception('Failed to load projects');
    }
  }

  Future<List<Project>> getUserInvites() async {
    await dotenv.load();
    final FirebaseAuth auth = FirebaseAuth.instance;
    String id = auth.currentUser!.uid;
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    String userToken = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $userToken'
    };
    final response = await http.get(
        Uri.parse('$baseUrl/api/v1/projects/invites/data?id=$id'),
        headers: headers);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final invitesJson = data['projects'] as List<dynamic>;
      final invites = invitesJson
          .map((invitesJson) => Project.fromJson(invitesJson))
          .toList();
      return invites;
    } else {
      throw Exception('Failed to load projects ${response.body}');
    }
  }

  Future<bool> acceptInvite(String inviteId) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse(
        '$baseUrl/api/v1/projects/invites/$inviteId/accept'); // Replace with your endpoint URL
    String userToken = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $userToken'
    };
    final body = jsonEncode({
      'creator_id': (await AuthService().getJwt())!,
      'status': 'created',
    });
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }

  Future<bool> rejectInvite(String inviteId) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse(
        '$baseUrl/api/v1/projects/invites/$inviteId/reject'); // Replace with your endpoint URL
    String userToken = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $userToken'
    };
    final body = jsonEncode({
      'creator_id': (await AuthService().getJwt())!,
      'status': 'created',
    });

    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }

  Future<Project> getProject(String projectId) async {
    try {
      await dotenv.load();
      final FirebaseAuth auth = FirebaseAuth.instance;
      String id = auth.currentUser!.uid;
      String baseUrl = dotenv.env['BACKENDBASEURL']!;
      String userToken = await getAccessToken();
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'bearer $userToken'
      };
      final response = await http.get(
          Uri.parse('$baseUrl/api/v1/projects/$projectId/data'),
          headers: headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final projectJson = data['project'] as Map<String, dynamic>;
        final project = Project.fromJson(projectJson);

        return project;
      } else {
        // Gestisci gli errori di stato della risposta
        throw Exception(
            'Failed to load projects. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Gestisci le eccezioni qui
      throw Exception('Failed to load projects. Exception: $e');
    }
  }

  Future<bool> createQuote(Quote quote) async {
    await dotenv.load();
    String baseUrl = dotenv.env['BACKENDBASEURL']!;
    final url = Uri.parse('$baseUrl/api/v1/projects/quotes');
    String userToken = await getAccessToken();
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'bearer $userToken'
    };
    final body = json.encode(quote.toJson());
    final response = await http.post(url, headers: headers, body: body);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
      //throw Exception('Failed to send POST request: ${response.statusCode}');
    }
  }
}
