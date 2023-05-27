import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/models/item.dart';
import 'package:rellai_frontend/models/sub_item.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';
import 'package:intl/intl.dart';

class AddItemPage extends StatefulWidget {
  final Item? item;
  final int? index;
  final bool enabled;
  final bool showEditButton;
  final String? creatorId;

  const AddItemPage({
    Key? key,
    this.item,
    this.index,
    this.enabled = true,
    this.creatorId,
    this.showEditButton = false,
  }) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController itemNameController;
  late TextEditingController itemTypeController;
  late TextEditingController newSubItemDescriptionController;
  late TextEditingController newSubItemUnitController;
  late TextEditingController newSubItemNumberController;
  late TextEditingController newSubItemUnitPriceController;

  Quotation? quote;
  bool enabled = true;
  bool isAddingNewRow = false;
  List<SubItem> subItems = [];
  List<String> units = [
    'Corpo',
    'Giorno lavorativo (d)',
    'Kilogrammo (kg)',
    'Litro (L)',
    'Metro cubo (m3)',
    'Metro lineare (m)',
    'Metro quadrato (m2)',
    'Ora lavorativa (h)',
    'Pezzo (PZ)',
    'Unità (U)',
  ];
  String? selectedUnit;

  // Lavorazione dropdown
  List<String> lavorazioneOptions = [
    'Assicurazione',
    'Cartongessi',
    'Carpenteria',
    'Certificazioni',
    'Costi generali',
    'Demolizioni',
    'Facciate',
    'Finiture',
    'Fondazioni',
    'Impianto di condizionamento',
    'Impianto elettrico',
    'Impianto idraulico',
    'Impianto di cantiere',
    'Impermeabilizzazione',
    'Opere edili',
    'Pavimentazione',
    'Permessi',
    'Progettazione',
    'Serramenti',
    'Smaltimento rifiuti',
    'Test e collaudo',
    'Tinteggitura',
    'Trasporti',
  ];
  String? selectedLavorazione;

  @override
  void initState() {
    super.initState();
    subItems = widget.item?.subItems ?? [];
    enabled = widget.enabled;
    nameController = TextEditingController(text: widget.item?.name ?? "");
    descriptionController = TextEditingController(text: "");
    itemNameController = TextEditingController(text: "");
    itemTypeController = TextEditingController(text: "");
    newSubItemDescriptionController = TextEditingController(text: "");
    newSubItemUnitController = TextEditingController(text: "");
    newSubItemNumberController = TextEditingController(text: "");
    newSubItemUnitPriceController = TextEditingController(text: "");
    if (widget.item != null) {
      nameController.text = widget.item!.name;
    }
  }

  void addSubItem(SubItem item) {
    setState(() {
      subItems.add(item);
    });
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    for (var item in subItems) {
      totalPrice += item.unitPrice * item.unitNumber;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lavorazione'),
        actions: [
          if (widget.enabled)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                Item item = Item(
                  name: selectedLavorazione ?? '',
                  subItems: subItems,
                );
                print(item.toJson());
                Navigator.pop(context, item);
              },
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!enabled || (widget.item != null))
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  border: OutlineInputBorder(),
                ),
                enabled: false,
              ),
            const SizedBox(height: 10),
            if (enabled && (widget.item == null))
              DropdownButtonFormField<String>(
                value: selectedLavorazione,
                decoration: const InputDecoration(
                  labelText: 'Seleziona una lavorazione',
                  border: OutlineInputBorder(),
                ),
                hint: const Text('Seleziona una lavorazione'),
                items: lavorazioneOptions.map((value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    selectedLavorazione = newValue;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Per procedere seleziona una lavorazione';
                  }
                  return null;
                },
              ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: subItems.length,
                itemBuilder: (context, index) {
                  return _buildSubItemRow(subItems[index], index);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: enabled
          ? FloatingActionButton(
              onPressed: () {
                if (selectedLavorazione == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Seleziona una Lavorazione'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                } else {
                  showModalBottomSheet<void>(
                    context: context,
                    isScrollControlled: true,
                    builder: (BuildContext context) {
                      return Padding(
                        padding: MediaQuery.of(context).viewInsets,
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                'Nuova Sottolavorazione',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                textCapitalization:
                                    TextCapitalization.sentences,
                                controller: newSubItemDescriptionController,
                                decoration: const InputDecoration(
                                  labelText: 'Descrizione',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 10),
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                ),
                                value: selectedUnit,
                                hint: const Text('Seleziona unità'),
                                items: units.map((value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    selectedUnit = newValue;
                                    if (newValue == 'Corpo') {
                                      newSubItemNumberController.text = '1';
                                    }
                                  });
                                },
                                validator: (value) {
                                  if (value == null) {
                                    return 'Seleziona una unità';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 10),
                              if (selectedUnit != 'Corpo')
                                TextField(
                                    controller: newSubItemNumberController,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'N. Unità',
                                    ),
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: false,
                                    )),
                              if (selectedUnit != 'Corpo')
                                const SizedBox(height: 10),
                              TextField(
                                  controller: newSubItemUnitPriceController,
                                  decoration: InputDecoration(
                                    border: const OutlineInputBorder(),
                                    labelText: (selectedUnit == 'Corpo')
                                        ? 'Prezzo'
                                        : 'Prezzo Unitario',
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                  )),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  SubItem newItem = SubItem(
                                    description:
                                        newSubItemDescriptionController.text,
                                    unitType: selectedUnit ?? 'm2',
                                    unitNumber: double.tryParse(
                                            newSubItemNumberController.text) ??
                                        1.0,
                                    unitPrice: double.parse(
                                      newSubItemUnitPriceController.text
                                          .replaceAll(',', '.')
                                          .replaceAll("'", ''),
                                    ),
                                  );
                                  setState(() {
                                    subItems.add(newItem);
                                  });
                                  newSubItemDescriptionController =
                                      TextEditingController(text: "");
                                  newSubItemUnitController =
                                      TextEditingController(text: "");
                                  newSubItemNumberController =
                                      TextEditingController(text: "");
                                  newSubItemUnitPriceController =
                                      TextEditingController(text: "");
                                  Navigator.pop(context);
                                },
                                child: const Text('Aggiungi'),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
              },
              child: const Icon(Icons.add),
            )
          : Container(),
      bottomNavigationBar: PriceBottomCard(
        showComplete: false,
        totalPrice: totalPrice,
      ),
    );
  }

  Widget _buildSubItemRow(SubItem subItem, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Text(
          (index + 1).toString(),
          style: const TextStyle(fontStyle: FontStyle.italic),
        ),
        title: Text(subItem.description),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Unità: ${subItem.unitType}'),
            Text('N. Unità: ${subItem.unitNumber}'),
            Text(
                'Prezzo: ${NumberFormat.currency(symbol: '€').format(subItem.unitPrice)}'),
            Text(
                'Prezzo totale: ${NumberFormat.currency(symbol: '€').format(subItem.unitPrice * subItem.unitNumber)}'),
          ],
        ),
        trailing: widget.enabled
            ? IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    subItems.removeAt(index);
                  });
                },
              )
            : null,
      ),
    );
  }
}
