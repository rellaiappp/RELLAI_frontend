import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/project.dart';

class ProjectCard extends StatefulWidget {
  final bool isHomeOwner;
  final Project project;
  final VoidCallback? onTap;

  const ProjectCard({
    Key? key,
    required this.isHomeOwner,
    required this.project,
    this.onTap,
  }) : super(key: key);

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Card(
            elevation: _isHovering ? 8.0 : 2.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project.detail.name,
                            style: theme.textTheme.titleLarge,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12.0),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on_outlined,
                                size: 18.0,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4.0),
                              Flexible(
                                child: Text(
                                  "${widget.project.site.address.street}, ${widget.project.site.address.city}, ${widget.project.site.address.region}",
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(widget.project.site.siteType,
                              style: theme.textTheme.bodySmall),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          color: _isHovering ? theme.primaryColor : Colors.grey,
                          size: 16.0,
                        ),
                        onPressed: widget.onTap,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
