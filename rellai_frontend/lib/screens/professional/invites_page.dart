import 'create_project_page.dart';
import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../services/api_service.dart';

class InvitesPage extends StatefulWidget {
  @override
  State<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {
  late Future<List<Project>> _invites;

  @override
  void initState() {
    super.initState();
    _invites = ApiService().getUserInvites();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Call your function here
    _invites = ApiService().getUserInvites();
  }

  Future<void> _refreshProjects() async {
    setState(() {
      _invites = ApiService().getUserInvites();
    });
  }

  void reloadScreen() {
    setState(() {
      _invites = ApiService().getUserInvites();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inviti'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: FutureBuilder(
          future: _invites,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return RefreshIndicator(
                onRefresh: _refreshProjects,
                child: ListView.builder(
                  itemCount: snapshot
                      .data!.length, // Set the number of items in the list
                  itemBuilder: (BuildContext context, int index) {
                    // Build a Card widget for each item in the list
                    return Card(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                            title: Text(
                                snapshot.data![index].projectInfo.projectName),
                            subtitle: Text(snapshot.data![index].id),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              TextButton(
                                child: const Text('Accetta'),
                                onPressed: () {
                                  ApiService()
                                      .acceptInvite(
                                          snapshot.data![index].invitationId ??
                                              'No id')
                                      .then((value) => reloadScreen());
                                },
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                child: const Text('Rifiuta'),
                                onPressed: () {
                                  ApiService()
                                      .acceptInvite(
                                          snapshot.data![index].invitationId ??
                                              'No id')
                                      .then((value) => reloadScreen());
                                },
                              ),
                              const SizedBox(width: 8),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
