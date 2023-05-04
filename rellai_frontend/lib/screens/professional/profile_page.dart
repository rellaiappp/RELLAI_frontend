import 'package:flutter/material.dart';
import 'package:rellai_frontend/screens/professional/edit_profile_page.dart';
import 'package:rellai_frontend/services/api_service.dart';
import 'package:rellai_frontend/models/user.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AppUser? user;

  @override
  void initState() {
    super.initState();
    ApiService().getUserInfo().then((data) {
      if (data != null) {
        setState(() {
          user = data;
          print(user!.name);
        });
      }
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage(user?.profilePictureUrl ??
                'https://www.cobdoglaps.sa.edu.au/wp-content/uploads/2017/11/placeholder-profile-sq.jpg'),
          ),
          const SizedBox(height: 16),
          Text(
            user?.name ?? "Nome Cognome",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user?.mail ?? "Email utente",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: () {
              // Navigator.of(context).push(
              //   MaterialPageRoute(
              //     builder: (context) => EditProfilePage(user: user!),
              //   ),
              // );
            },
            child: const Text('Modifica il profilo'),
          ),
          // Add more profile information and posts here
        ],
      ),
    );
  }
}
