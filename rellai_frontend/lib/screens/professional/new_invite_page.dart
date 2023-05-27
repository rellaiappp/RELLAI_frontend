import 'package:flutter/material.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/utils/show_dialog.dart';

class NewInvitePage extends StatefulWidget {
  final String projectId;

  const NewInvitePage({super.key, required this.projectId});

  @override
  State<NewInvitePage> createState() => _NewInvitePageState();
}

class _NewInvitePageState extends State<NewInvitePage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  var _inviteData = {};
  final _formKey = GlobalKey<FormState>();
  String? _value = "client";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Invia un invito"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Nome",
                        border: OutlineInputBorder(),
                      ),
                      controller: _firstNameController,
                      onSaved: (value) {
                        _inviteData['firstName'] = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: "Cognome",
                        border: OutlineInputBorder(),
                      ),
                      controller: _lastNameController,
                      onSaved: (value) {
                        _inviteData['lastName'] = value;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      controller: _emailController,
                      onSaved: (value) {
                        _value = value;
                      },
                      validator: (value) {
                        if (!value!.contains('@')) {
                          return 'Indirizzo email non valido';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    DropdownButtonFormField(
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(
                          value: 'client',
                          child: Text('Cliente'),
                        ),
                        DropdownMenuItem(
                          value: 'b',
                          child: Text('Impresa'),
                        ),
                      ],
                      value: 'client',
                      onChanged: (value) {
                        _value = value;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: const Text("Invia"),
        icon: const Icon(Icons.send),
        onPressed: () async {
          // Do something
          if (_formKey.currentState!.validate()) {
            // Submit the form
            await ProjectCRUD().createInvitation(
                widget.projectId, _value!, _emailController.text);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Invito inviato con successo!'),
                duration:
                    Duration(seconds: 3), // Imposta la durata a tuo piacimento
              ),
            );
            Navigator.pop(context, _inviteData);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Inserisci tutti i campi richiesti'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        },
      ),
    );
  }
}
