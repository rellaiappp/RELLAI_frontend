import 'package:flutter/material.dart';
import 'package:rellai_frontend/screens/professional/edit_profile_page.dart';
import 'package:rellai_frontend/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rellai_frontend/screens/auth/login_page.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/user_provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  AppUser? user;
  TextEditingController businessNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController regionController = TextEditingController();

  Future<void> _signOut(context) async {
    try {
      await auth.signOut();
      final ProjectProvider projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      final ProjectProvider userProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      projectProvider.clearAll();
      userProvider.clearAll();
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  void updatePagetUser(AppUser? currentUser) {
    if (currentUser != null) {
      setState(() {
        businessNameController.text =
            currentUser.businessInfo?.businessName ?? '';
        addressController.text = currentUser.address?.street ?? '';
        cityController.text = currentUser.address?.city ?? '';
        regionController.text = currentUser.address?.region ?? '';
      });
    }
  }

  @override
  void dispose() {
    businessNameController.dispose();
    addressController.dispose();
    cityController.dispose();
    regionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    updatePagetUser(userProvider.user);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profilo'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
              onPressed: () {
                _signOut(context);
                Navigator.pushReplacement<void, void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const LoginPage(),
                  ),
                );
              },
              child: Text(
                "Logout",
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ))
        ],
      ),
      body: userProvider.user == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 46),
                    // CircleAvatar(
                    //   radius: 50,
                    //   backgroundImage: userProvider.user?.profileImageUrl ==
                    //           null
                    //       ? const AssetImage('assets/placeholder-profile.jpeg')
                    //           as ImageProvider
                    //       : NetworkImage(userProvider.user!.profileImageUrl!),
                    // ),
                    const SizedBox(height: 16),
                    Text(
                      "${userProvider.user?.firstName ?? 'Nome'} ${userProvider.user?.lastName ?? 'Cognome'}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      userProvider.user?.email ?? "Email utente",
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey,
                      ),
                    ),
                    (userProvider.user?.phone != null &&
                            userProvider.user!.phone! != '')
                        ? Column(
                            children: [
                              const SizedBox(height: 8),
                              Text(
                                userProvider.user!.phone!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          )
                        : Container(),
                    const SizedBox(height: 4),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                EditProfilePage(user: userProvider.user!),
                          ),
                        );
                      },
                      child: const Text('Modifica il profilo'),
                    ),
                    const Divider(
                      color: Colors.grey,
                      height: 32,
                      thickness: 0.5,
                      indent: 45,
                      endIndent: 45,
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (businessNameController.text != '')
                            TextField(
                              controller: businessNameController,
                              decoration: const InputDecoration(
                                labelText: 'Nome attività',
                              ),
                              maxLines: null,
                              enabled: false,
                            ),
                          const SizedBox(height: 8),
                          if (addressController.text != '')
                            TextField(
                              controller: addressController,
                              decoration: const InputDecoration(
                                labelText: 'Indirizzo',
                              ),
                              maxLines: null,
                              enabled: false,
                            ),
                          const SizedBox(height: 8),
                          if (cityController.text != '')
                            TextField(
                              controller: cityController,
                              decoration: const InputDecoration(
                                labelText: 'Città',
                              ),
                              maxLines: null,
                              enabled: false,
                            ),
                          const SizedBox(height: 8),
                          if (regionController.text != '')
                            TextField(
                              controller: regionController,
                              decoration: const InputDecoration(
                                labelText: 'Provincia',
                              ),
                              maxLines: null,
                              enabled: false,
                            ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
