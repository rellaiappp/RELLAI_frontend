import 'package:http/http.dart' as http;
import 'package:rellai_frontend/models/invite.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/models/project.dart';
import 'package:rellai_frontend/models/sal.dart';
import 'package:rellai_frontend/models/variation.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rellai_frontend/screens/old/email.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ProjectCRUD {
  // String varurl = "https://rellai.uc.r.appspot.com";

  String varurl = "http://10.0.2.2:8080 ";
  Future<String?> createProject(Project project) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    String url = '$baseUrl/projects'; // Replace with your actual API URL

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}',
            'disable-redirects': 'true'
          },
          body: json.encode(project.toJson()));

      if (response.statusCode == 201) {
        print('Project created successfully');
        createInvitation(
            json.decode(response.body)['id'], 'client', project.client.email);

        return json.decode(response.body)['id'];
      } else {
        print(response.body);
        throw Exception('Failed to create project');
      }
    } catch (error) {
      print(error);
    }
    return null;
  }

  Future<List<Project>> fetchProjects() async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    var url = Uri.parse('$baseUrl/projects');
    print(await FirebaseAuth.instance.currentUser!.getIdToken());
    List<Project> projects = [];
    print(FirebaseAuth.instance.currentUser!.getIdToken());
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}',
        'disable-redirects': 'true'
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        List<dynamic> jsonData = jsonDecode(response.body);
        projects =
            jsonData.map((project) => Project.fromJson(project)).toList();
        // Now you can use the data as per your need
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e, s) {
      print("$e this is the error");
      print("$s this is the stacktrace");
    }
    return projects;
  }

  Future<Project?> fetchProject(String id) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    var url = Uri.parse('$baseUrl/projects/?projectId=$id');
    Project? project;
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization':
            'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}',
      };
      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);
        project = Project.fromJson(jsonData);
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e, s) {
      print("$e this is the error");
      print("$s this is the stacktrace");
    }
    return project;
  }

  Future<void> createQuotation(Quotation quote, String projectId) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    String url =
        '$baseUrl/projects/quotes/'; // Replace with your actual API URL

    try {
      final response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization':
                'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
          },
          body: json.encode(quote.toJson()));

      if (response.statusCode == 201) {
        print('Project created successfully');
      } else {
        print(response.body);
        throw Exception('Failed to create project');
      }
    } catch (error) {
      print(error);
    }
  }

  Future<List<Invite>> getInvitations() async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = "https://rellai.uc.r.appspot.com";
    List<Invite> pendingInvitations = [];
    final url = Uri.parse('$baseUrl/projects/invites');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };
    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body)
            as List<dynamic>; // Cast responseData to Map<String, dynamic>
        final invitations = responseData; // Cast invitations to List<dynamic>
        pendingInvitations = invitations
            .map((invite) => Invite.fromJson(invite
                as Map<String, dynamic>)) // Cast invite to Map<String, dynamic>
            .toList();
      } else {
        print('Failed to retrieve pending invitations ${response.body}');
      }
    } catch (e, s) {
      print('Error: $e');
      print('Stacktrace: $s');
    }
    return pendingInvitations;
  }

  Future<void> createInvitation(
      String projectId, String role, String email) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url = Uri.parse('$baseUrl/projects/invites');

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = jsonEncode({
      'role': role,
      'email': email,
      'projectId': projectId,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Invitation created successfully');
        final responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        print('Failed to create invitation');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateInvitation(String inviteID,
      {bool accepted = false, bool rejected = false}) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url = Uri.parse('$baseUrl/projects/invites/$inviteID');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = jsonEncode({'accepted': accepted, 'rejected': rejected});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Invitation updated successfully');
      } else {
        print(
            'Failed to update invitation. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating invitation: $error');
    }
  }

  Future<void> updateQuote(String quoteId,
      {bool accepted = false, bool rejected = false}) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url = Uri.parse('$baseUrl/projects/quotes/?quoteId=$quoteId');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = jsonEncode({'accepted': accepted, 'rejected': rejected});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Quote updated successfully');
      } else {
        print('Failed to update quote. Status code: ${response.statusCode}');
        print(response.body);
      }
    } catch (error) {
      print('Error updating quote: $error');
    }
  }

  Future<void> createVariation(Variation variation) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url = Uri.parse('$baseUrl/projects/variations');

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = json.encode(variation.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Invitation created successfully');
        final responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        print('Failed to create invitation');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateVariation(String variationId,
      {bool accepted = false, bool rejected = false}) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url =
        Uri.parse('$baseUrl/projects/variations/?variationId=$variationId');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = jsonEncode({'accepted': accepted, 'rejected': rejected});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Invitation updated successfully');
      } else {
        print(
            'Failed to update variation. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating variation: $error');
    }
  }

  Future<void> createSal(Sal sal) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url = Uri.parse('$baseUrl/projects/sals');

    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = json.encode(sal.toJson());

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        print('Invitation created successfully');
        final responseData = jsonDecode(response.body);
        print(responseData);
      } else {
        print('Failed to create invitation');
        print('Status Code: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      print('Error: $error');
    }
  }

  Future<void> updateSal(String salId,
      {bool accepted = false, bool rejected = false}) async {
    await dotenv.load(fileName: ".env");
    var baseUrl = dotenv.env['BACKENDBASEURL'];
    baseUrl = varurl;
    final url = Uri.parse('$baseUrl/projects/sals/$salId');
    final headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization':
          'bearer ${await FirebaseAuth.instance.currentUser!.getIdToken()}'
    };

    final body = jsonEncode({'accepted': accepted, 'rejected': rejected});

    try {
      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Invitation updated successfully');
      } else {
        print(
            'Failed to update invitation. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error updating invitation: $error');
    }
  }
}
