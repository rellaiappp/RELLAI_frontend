import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/project.dart';

class ProjectCard extends StatelessWidget {
  final bool isHomeOwner;
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard(
      {Key? key, required bool isHomeOwner, required this.project, this.onTap})
      : isHomeOwner = isHomeOwner,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                project.projectInfo.projectName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                !isHomeOwner
                    ? project.client.nome
                    : project.creator?.name ?? 'Unknown creator',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(project.projectInfo.projectType),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (project.total != null)
                    Text(
                      project.total! > 0
                          ? "Totale: €${project.total!.toStringAsFixed(2)}"
                          : "",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
