import 'package:flutter/material.dart';
import 'projects_page.dart';
import 'profile_page.dart';
import 'invites_page.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';
import 'package:rellai_frontend/providers/user_provider.dart';
import 'package:badges/badges.dart' as badges;

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const ProjectsPage(),
    const ProfilePage(),
    const InvitesPage(),
  ];

  void _onDestinationSelected(int index) {
    HapticFeedback.heavyImpact(); // Trigger haptic feedback

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    projectProvider.updateProjects();
    projectProvider.updateInvites();
    userProvider.updateUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            return false;
          },
          child: _screens[_currentIndex]),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white, // Customize the background color
        selectedItemColor:
            Theme.of(context).primaryColor, // Customize the selected item color
        unselectedItemColor: Colors.grey, // Customize the unselected item color
        currentIndex: _currentIndex,
        onTap: _onDestinationSelected,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Progetti',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profilo',
          ),
          BottomNavigationBarItem(
            icon: ((Provider.of<ProjectProvider>(context).invites != null) &&
                    (Provider.of<ProjectProvider>(context).invites!.isNotEmpty))
                ? Badge(
                    label: Text(
                        "${Provider.of<ProjectProvider>(context).invites!.length}"),
                    backgroundColor: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                    child: const Icon(Icons.mail))
                : const Icon(Icons.mail),
            label: 'Inviti',
          ),
        ],
      ),
    );
  }
}
