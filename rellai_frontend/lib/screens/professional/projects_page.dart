import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rellai_frontend/widgets/ProjectCard.dart';
import 'create_project_page.dart';
import 'project_details_page.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';
import 'package:rellai_frontend/providers/user_provider.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({Key? key}) : super(key: key);
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  final bool _isHomeOwner = true;

  @override
  void initState() {
    super.initState();
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    projectProvider.updateProjects();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progetti'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: projectProvider.projects == null
            ? const CircularProgressIndicator()
            : RefreshIndicator(
                onRefresh: projectProvider.updateProjects,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ListView.builder(
                    itemCount: projectProvider.projects!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final project = projectProvider.projects![index];
                      return ProjectCard(
                        project: project,
                        isHomeOwner: _isHomeOwner,
                        onTap: () {
                          HapticFeedback.mediumImpact();
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
                ),
              ),
      ),
      floatingActionButton: (userProvider.user?.role != "homeowner")
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const NewProjectPage()));
              },
              label: const Text('Nuovo'),
              icon: const Icon(Icons.edit))
          : Container(),
    );
  }
}
