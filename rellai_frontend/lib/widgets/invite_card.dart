import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/invite.dart';

class InviteCard extends StatelessWidget {
  final Invite invite;
  final Function() onEnterProject;

  const InviteCard({
    super.key,
    required this.invite,
    required this.onEnterProject,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Text(
              invite.project.name,
              style: Theme.of(context).textTheme.titleLarge!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Text(
              "${invite.sender.firstName} ${invite.sender.lastName}",
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 16),
            child: Text(
              "${invite.project.address.street},${invite.project.address.city} ,${invite.project.address.region} ,${invite.project.address.zipCode}",
              style: Theme.of(context).textTheme.bodySmall!,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: ElevatedButton(
                onPressed: onEnterProject,
                child: Text('Entra nel progetto'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
