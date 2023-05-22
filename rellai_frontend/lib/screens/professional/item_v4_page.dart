import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/models/item.dart';
import 'package:rellai_frontend/models/sub_item.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';

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
  List<String> units = ['m2', 'Unità', 'Corpo'];
  String? selectedUnit;

  @override
  void initState() {
    super.initState();
    subItems = widget.item?.subItems ?? [];
    enabled = widget.enabled;
    nameController = TextEditingController(text: widget.item?.name ?? "");
    descriptionController = TextEditingController();
    itemNameController = TextEditingController();
    itemTypeController = TextEditingController();
    newSubItemDescriptionController = TextEditingController();
    newSubItemUnitController = TextEditingController();
    newSubItemNumberController = TextEditingController();
    newSubItemUnitPriceController = TextEditingController();
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
                  name: nameController.text,
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
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
              ),
              enabled: enabled,
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
                              'Sottolavorazione',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: newSubItemDescriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            DropdownButtonFormField<String>(
                              value: selectedUnit,
                              hint: const Text('Select unit'),
                              items: units.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedUnit = newValue;
                                });
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a unit';
                                }
                                return null;
                              },
                            ),
                            if (selectedUnit != 'Corpo')
                              TextField(
                                controller: newSubItemNumberController,
                                decoration: const InputDecoration(
                                  labelText: 'N. Unità',
                                ),
                              ),
                            TextField(
                              controller: newSubItemUnitPriceController,
                              decoration: const InputDecoration(
                                labelText: 'Prezzo',
                              ),
                            ),
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
            Text('Prezzo: € ${subItem.unitPrice}'),
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
