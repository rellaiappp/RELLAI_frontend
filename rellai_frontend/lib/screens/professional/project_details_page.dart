// project_details_page.dart
import 'package:flutter/material.dart';
import 'package:rellai_frontend/services/api_service.dart';
import 'package:rellai_frontend/screens/professional/quote_page.dart'; // Import the new page here.
import '../../models/project.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  Project? _projectData;

  @override
  void initState() {
    super.initState();
    _projectData = widget.project;
    _loadProject();
  }

  void _loadProject() async {
    await ApiService()
        .getProject(widget.project.id)
        .then((value) => setState(() {
              _projectData = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli progetto'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.add),
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem<String>(
                value: 'quotation',
                child: Text('Quotazione'),
              ),
              const PopupMenuItem<String>(
                value: 'variation_order',
                child: Text('Variation Order'),
              ),
              const PopupMenuItem<String>(
                value: 'change_order',
                child: Text('Change Order'),
              ),
            ],
            onSelected: (String value) {
              _navigateToNewPage(context, value);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildTextField(
                    'Project Name', widget.project.projectInfo.projectName),
                const SizedBox(height: 10),
                buildTextField('Client Name', widget.project.client.nome),
                const SizedBox(height: 10),
                buildTextField(
                    'Project Type', widget.project.projectInfo.projectType),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
                child: _projectData != null && _projectData!.quotations != null
                    ? ListView.builder(
                        itemCount: _projectData!.quotations!.length,
                        itemBuilder: (BuildContext context, int index) {
                          final item = _projectData!.quotations![index];
                          return Card(
                            child: Column(children: [
                              ListTile(
                                  title: Text(item.quoteName),
                                  subtitle: Text(item.quoteType),
                                  trailing: Text('\$${item.id}'),
                                  onTap: () {
                                    print(item.toJson());
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddQuotePage(
                                                  quote: item,
                                                  quoteType: item.quoteType,
                                                  projectId: widget.project.id,
                                                  enabled: false,
                                                  showEditButton: false,
                                                )));
                                  }),
                            ]),
                          );
                        },
                      )
                    : const SizedBox(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextFormField buildTextField(String labelText, String initialValue) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      initialValue: initialValue,
      enabled: false,
    );
  }

  void _navigateToNewPage(BuildContext context, String selectedItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuotePage(
          quoteType: selectedItem,
          projectId: widget.project.id,
        ),
      ),
    ).then((value) => _loadProject());
  }
}
