import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/invite.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/widgets/invite_card.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';

class InvitesPage extends StatefulWidget {
  const InvitesPage({super.key});

  @override
  State<InvitesPage> createState() => _InvitesPageState();
}

class _InvitesPageState extends State<InvitesPage> {
  @override
  void initState() {
    super.initState();
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    projectProvider.updateInvites();
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Inviti'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: projectProvider.invites == null
            ? const CircularProgressIndicator()
            : RefreshIndicator(
                onRefresh: projectProvider.updateInvites,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: ListView.builder(
                    itemCount: projectProvider.invites!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final invite = projectProvider.invites![index] as Invite;
                      return InviteCard(
                        invite: invite,
                        onEnterProject: () async {
                          await ProjectCRUD()
                              .updateInvitation(invite.id, accepted: true);
                          projectProvider.updateInvites();
                        },
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
