import 'package:flutter/material.dart';
import '../../models/project.dart';
import '../../services/api_service.dart';
import 'project_details_page.dart';
import 'create_project_page.dart';
import 'package:rellai_frontend/models/user_model.dart';
import 'package:rellai_frontend/widgets/ProjectCard.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  late Future<List<Project>> _projects;
  bool _isHomeOwner = true;

  @override
  void initState() {
    super.initState();
    ApiService().getUserInfo().then((AppUser value) {
      setState(() {
        if (value.role == 'homeowner') {
          _isHomeOwner = true;
        } else {
          _isHomeOwner = false;
        }
      });
    });
    _projects = _fetchProjects();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _projects = _fetchProjects();
  }

  Future<List<Project>> _fetchProjects() async {
    return ApiService().fetchProjects();
  }

  Future<void> _refreshProjects() async {
    setState(() {
      _projects = _fetchProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Projects'),
        automaticallyImplyLeading: false,
        actions: [
          if (!_isHomeOwner)
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewProjectPage()),
                );
              },
              child: const Text('Crea'),
            )
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder<List<Project>>(
            future: _projects,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                return RefreshIndicator(
                  onRefresh: _refreshProjects,
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final project = snapshot.data![index];
                      return ProjectCard(
                        project: project,
                        isHomeOwner: _isHomeOwner,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProjectDetailsPage(
                                project: project,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
