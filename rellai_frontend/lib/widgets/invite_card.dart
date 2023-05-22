import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/invite.dart';

class InviteCard extends StatelessWidget {
  final Invite invite;
  final Function() onAccept;
  final Function() onReject;

  const InviteCard({super.key, 
    required this.invite,
    required this.onAccept,
    required this.onReject,
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: onAccept,
                child: const Text('Accetta'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: onReject,
                child: const Text('Rifiuta'),
              ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}
