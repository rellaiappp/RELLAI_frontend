import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/project_user.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/screens/professional/new_invite_page.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';

class UserListScreen extends StatefulWidget {
  final String projectId;

  const UserListScreen({Key? key, required this.projectId}) : super(key: key);

  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<ProjectUser>? users;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future fetchData() async {
    var userList = await ProjectCRUD().getUsers(widget.projectId);
    setState(() {
      users = userList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista accessi'),
      ),
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: fetchData,
        child: users == null
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ListView.builder(
                  itemCount: users!.length,
                  itemBuilder: (context, index) {
                    ProjectUser user = users![index];
                    return Dismissible(
                      key: Key(user.id
                          .toString()), // assume each user has a unique id
                      onDismissed: (direction) {
                        // implement your item deletion logic here
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            title: Text(
                              '${user.firstName} ${user.lastName}',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.normal),
                            ),
                            subtitle: Text(
                              'Email: ${user.email}\nAccess Level: ${(user.accessLevel.contains('c') && user.accessLevel != 'client') ? "Azienda" : "Committente"}',
                              style: TextStyle(fontSize: 12),
                            ),
                            isThreeLine: true,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NewInvitePage(
                  projectId: widget.projectId,
                ),
              ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
