import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/screens/professional/quote_v2_page.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';
import 'package:rellai_frontend/widgets/quote_card.dart';
import '../../models/project.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';
import 'package:rellai_frontend/widgets/chat_widget.dart';
import 'package:rellai_frontend/screens/professional/new_invite_page.dart';
import 'package:rellai_frontend/screens/professional/project_group.dart';

class ProjectDetailsPage extends StatefulWidget {
  final Project project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  Project? _projectData;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      projectProvider.setCurrentProject(widget.project);
      projectProvider.updateCurrentProject();
      setState(() {
        _projectData = projectProvider.currentProject;
      });
    });
    if (widget.project != null) {
      nameController.text = widget.project.detail.name;
      typeController.text = widget.project.detail.projectType;
      addressController.text =
          "${widget.project.site.address.street}, ${widget.project.site.address.city}";
    }
  }

  void _loadProject() async {}

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    double totalPrice = 0.0;

    if (projectProvider.currentProject != null) {
      for (var quote in projectProvider.currentProject!.quotes) {
        if (quote.rejected != true) {
          for (var item in quote.items) {
            for (var subItem in item.subItems) {
              totalPrice += subItem.unitNumber * subItem.unitPrice;
            }
          }
          for (var variation in quote.variations) {
            for (var item in variation.items) {
              for (var subItem in item.subItems) {
                totalPrice += subItem.unitNumber * subItem.unitPrice;
              }
            }
          }
        }
      }
    }
    _projectData = projectProvider.currentProject;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dettagli progetto'),
        actions: [
          if (_projectData != null && _projectData!.accessLevel!.contains('a'))
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UserListScreen(
                      projectId: widget.project.id!,
                    ),
                  ),
                ).then((value) => _loadProject());
              },
              icon: const Icon(
                Icons.group,
                color: Colors.black,
              ),
            ),
          if (_projectData != null && _projectData!.accessLevel!.contains("b"))
            IconButton(
              onPressed: () => _navigateToNewPage(context, "quotation"),
              icon: const Icon(
                Icons.add,
                color: Colors.black,
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DetailsWidget(
              comp1Controller: nameController,
              comp2Controller: typeController,
              comp3Controller: addressController,
            ),
            Expanded(
              child: _projectData?.quotes != null &&
                      _projectData!.quotes.isNotEmpty
                  ? ListView.builder(
                      itemCount: _projectData!.quotes.length,
                      itemBuilder: (BuildContext context, int index) {
                        return QuoteCard(
                          roleProject: widget.project.accessLevel!,
                          quote: _projectData!.quotes[index],
                          projectId: widget.project.id!,
                          loadProject: _loadProject,
                        );
                      },
                    )
                  : const SizedBox(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PriceBottomCard(
        totalPrice:
            _projectData != null ? computeTotal(_projectData!.quotes) : 0.0,
        showComplete: false,
      ),
    );
  }

  void _navigateToNewPage(BuildContext context, String selectedItem) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddQuotePage(
          quoteType: selectedItem,
          projectId: widget.project.id!,
        ),
      ),
    ).then((value) => _loadProject());
  }

  double computeTotal(List<Quotation> quotes) {
    double total = 0.0;
    for (final quote in quotes) {
      if (!quote.rejected) {
        for (final item in quote.items) {
          for (final subItem in item.subItems) {
            total += subItem.unitNumber * subItem.unitPrice;
          }
        }
        for (final variation in quote.variations) {
          for (final item in variation.items) {
            for (final subItem in item.subItems) {
              total += subItem.unitNumber * subItem.unitPrice;
            }
          }
        }
      }
    }
    return total;
  }
}

class DetailsWidget extends StatelessWidget {
  final TextEditingController comp1Controller;
  final TextEditingController comp2Controller;
  final TextEditingController comp3Controller;

  DetailsWidget({
    required this.comp1Controller,
    required this.comp2Controller,
    required this.comp3Controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          TextField(
            controller: comp1Controller,
            decoration: const InputDecoration(
              labelText: 'Nome progetto',
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: comp2Controller,
            decoration: const InputDecoration(
              labelText: 'Tipologia intervento',
              border: OutlineInputBorder(),
            ),
            enabled: false,
          ),
          const SizedBox(height: 12),
          TextField(
            controller: comp3Controller,
            decoration: const InputDecoration(
                labelText: 'Indirizzo', border: OutlineInputBorder()),
            enabled: false,
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
