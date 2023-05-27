import 'package:flutter/material.dart';
import 'package:rellai_frontend/screens/professional/routing_page.dart';
import 'package:rellai_frontend/models/project.dart';
import 'package:rellai_frontend/services/api/project.dart';

class NewProjectPage extends StatefulWidget {
  final Project? project;

  const NewProjectPage({Key? key, this.project}) : super(key: key);

  @override
  State<NewProjectPage> createState() => _NewProjectPageState();
}

class _NewProjectPageState extends State<NewProjectPage> {
  final _formKey = GlobalKey<FormState>();

  String _projectType = '';
  String _projectName = '';

  String _siteType = '';
  String _constructionYear = '';
  String _siteSurface = '';
  String _siteFloor = '';
  String _siteAddress = '';
  String _siteCity = '';
  String _siteRegion = '';
  String _siteZip = '';

  String _clientFirstName = '';
  String _clientLastName = '';
  String _clientEmail = '';

  Future<bool> createProject() async {
    Client client = Client(
        firstName: _clientFirstName,
        lastName: _clientLastName,
        email: _clientEmail);
    Detail detail =
        Detail(projectType: _projectType, name: _projectName, description: "");
    Address address = Address(
      street: _siteAddress,
      city: _siteCity,
      region: _siteRegion,
      state: "Italy",
      zipCode: _siteZip,
    );
    Site site = Site(
        constructionYear: _constructionYear,
        surface: double.tryParse(_siteSurface) ?? 0,
        siteType: _siteType,
        floor: int.parse(_siteFloor),
        address: address);
    Project project = Project(client: client, detail: detail, site: site);
    ProjectCRUD().createProject(project);
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Inserimento dati progetto',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: GestureDetector(
        onTap: () {
          //FocusScope.of(context).unfocus();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Informazioni generali',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                buildDropdownFormField(
                  'Tipologia di intervento',
                  [
                    'Costruzioni speciali',
                    'Edilizia',
                    'Gestione e organizzazione',
                    'Impiantistica',
                    'Involucro edile',
                  ],
                  (value) => _projectType = value!,
                ),
                buildFormInputField(
                  'Nome progetto',
                  TextInputType.text,
                  (value) => _projectName = value!,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Dettagli sito',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                buildDropdownFormField(
                  'Tipologia abitazione',
                  [
                    'Appartamento',
                    'Attico',
                    'Casa a schiera',
                    'Casa prefabbricata',
                    'Casa unifamiliare',
                    'Condominio',
                    'Loft',
                    'Villa',
                  ],
                  (value) => _siteType = value!,
                ),
                buildFormInputField(
                  'Anno costruzione edificio',
                  TextInputType.number,
                  (value) => _constructionYear = value!,
                ),
                buildFormInputField(
                  'Superfice',
                  TextInputType.number,
                  (value) => _siteSurface = value!,
                ),
                buildFormInputField(
                  'Piano',
                  TextInputType.number,
                  (value) => _siteFloor = value!,
                ),
                buildFormInputField(
                  'Indirizzo',
                  TextInputType.text,
                  (value) => _siteAddress = value!,
                ),
                buildFormInputField(
                  'Città',
                  TextInputType.text,
                  (value) => _siteCity = value!,
                ),
                buildFormInputField(
                  'Provincia',
                  TextInputType.text,
                  (value) => _siteRegion = value!,
                ),
                buildFormInputField(
                  'CAP',
                  TextInputType.text,
                  (value) => _siteZip = value!,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Dati committente',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                buildFormInputField(
                  'Nome',
                  TextInputType.text,
                  (value) => _clientFirstName = value!,
                ),
                buildFormInputField(
                  'Cognome',
                  TextInputType.text,
                  (value) => _clientLastName = value!,
                ),
                buildFormInputField(
                  'Email',
                  TextInputType.emailAddress,
                  (value) => _clientEmail = value!,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _formKey.currentState!.save();
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return FutureBuilder<bool>(
                  future: createProject(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const AlertDialog(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(width: 20),
                            Text('Creazione del progetto...'),
                          ],
                        ),
                      );
                    } else {
                      if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !snapshot.data!) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Errore durante la creazione del progetto'),
                          ),
                        );
                      } else {
                        WidgetsBinding.instance!.addPostFrameCallback((_) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainScreen()),
                          );
                        });
                      }

                      return Container(); // Empty container to close the dialog
                    }
                  },
                );
              },
            );
          }
        },
        child: const Icon(Icons.check),
      ),
    );
  }

  Widget buildFormInputField(
    String labelText,
    TextInputType keyboardType,
    Function(String?) onSaved,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        textCapitalization: TextCapitalization.sentences,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Inserisci $labelText';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }

  Widget buildDropdownFormField(
    String labelText,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField(
        isExpanded: true,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item,
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
              );
            }),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Seleziona $labelText';
          }
          return null;
        },
      ),
    );
  }
}
