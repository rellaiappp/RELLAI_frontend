import 'package:flutter/material.dart';
import 'package:rellai_frontend/screens/professional/routing_page.dart';
import '../../services/api_service.dart';
import '../../services/auth.dart';

class NewProjectPage extends StatefulWidget {
  @override
  _NewProjectPageState createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  String _nomeProgetto = '';
  String _tipologiaAbitazione = '';
  String _etaEdificio = '';
  String _metriQuadrati = '';
  String _tipoIntervento = '';
  String _nome = '';
  String _email = '';
  String _numeroCellulare = '';

  Future<bool> createProject() async {
    Map<String, String> site = {
      'nome_progetto': _nomeProgetto,
      'tipologia_abitazione': _tipologiaAbitazione,
      'eta_edificio': _etaEdificio,
      'metri_quadrati': _metriQuadrati,
      'tipo_intervento': _tipoIntervento,
    };
    Map<String, String> homeowner = {
      'nome': _nome,
      'email': _email,
      'numero_cellulare': _numeroCellulare,
    };

    bool result = await ApiService().createProject(site, homeowner);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Inserimento dati progetto')),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inserimento dati progetto',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Nome progetto'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci il nome del progetto';
                      }
                      return null;
                    },
                    onSaved: (value) => _nomeProgetto = value!,
                  ),
                  DropdownButtonFormField(
                    decoration: const InputDecoration(
                        labelText: 'Tipologia abitazione'),
                    items: const [
                      DropdownMenuItem(
                        value: 'appartamento',
                        child: Text('Appartamento'),
                      ),
                      DropdownMenuItem(
                        value: 'casa unifamiliare',
                        child: Text('Casa unifamiliare'),
                      ),
                      DropdownMenuItem(
                        value: 'altro',
                        child: Text('Altro'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _tipologiaAbitazione = value.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleziona la tipologia abitazione';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Età edificio'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci l\'età dell\'edificio';
                      }
                      return null;
                    },
                    onSaved: (value) => _etaEdificio = value!,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Metri quadrati'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci i metri quadrati';
                      }
                      return null;
                    },
                    onSaved: (value) => _metriQuadrati = value!,
                  ),
                  DropdownButtonFormField(
                    decoration:
                        const InputDecoration(labelText: 'Tipo di intervento'),
                    items: const [
                      DropdownMenuItem(
                        value: 'sostituzione impianti',
                        child: Text('Sostituzione impianti'),
                      ),
                      DropdownMenuItem(
                        value: 'adeguamento energetico',
                        child: Text('Adeguamento energetico'),
                      ),
                      DropdownMenuItem(
                        value: 'altro',
                        child: Text('Altro'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _tipoIntervento = value.toString();
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Seleziona il tipo di intervento';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  const Text('Dati committente',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci il nome';
                      }
                      return null;
                    },
                    onSaved: (value) => _nome = value!,
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci l\'email';
                      }
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Numero di cellulare'),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Inserisci il numero di cellulare';
                      }
                      return null;
                    },
                    onSaved: (value) => _numeroCellulare = value!,
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              print(_nomeProgetto);
              bool isSuccess = await createProject();

              if (isSuccess) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MainScreen()),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Errore durante la creazione del progetto'),
                  ),
                );
              }
              // Aggiungi la tua funzione per inviare i dati tramite POST request
            }

            // Aggiungi la tua funzione per inviare i dati tramite POST request
          },
          child: Icon(Icons.check),
        ));
  }
}
