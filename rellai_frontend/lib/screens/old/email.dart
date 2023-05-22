import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MailgunMailer {
  Future<void> sendInviteEmail(String toEmailAddress) async {
    String apiKey = 'f8291c782b9775964ef71cc9f8a34391-6b161b0a-b7a8dc1a';
    String domain = 'rellai.com';
    String fromEmail = 'noreply@rellai.com';
    String toEmail = toEmailAddress;
    final String htmlContent =
        await rootBundle.loadString('assets/invite.html');

    String apiRoot = 'https://api.mailgun.net/v3/$domain/messages';
    String authn = 'api:$apiKey';

    final headers = {
      'Authorization': 'Basic ${base64Encode(utf8.encode(authn))}',
    };

    final payload = {
      'from': fromEmail,
      'to': toEmail,
      'subject': 'Benvenuto da RELLAI',
      //'text': "Ciao come stai?",
      'html': htmlContent,
    };

    final response = await http.post(
      Uri.parse(apiRoot),
      headers: headers,
      body: payload,
    );

    if (response.statusCode == 200) {
      print('Email sent');
    } else {
      print('Failed to send email: ${response.body}');
    }
  }
}
