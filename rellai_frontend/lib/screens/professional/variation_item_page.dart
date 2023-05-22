import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/models/variation_item.dart';
import 'package:rellai_frontend/models/variation_sub_item.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';

class AddVariationItemPage extends StatefulWidget {
  final VariationItem? item;
  final int? index;
  final bool enabled;
  final bool showEditButton;
  final String? creatorId;
  const AddVariationItemPage(
      {Key? key,
      this.item,
      this.index,
      this.enabled = true,
      this.creatorId,
      this.showEditButton = false})
      : super(key: key);
  @override
  State<AddVariationItemPage> createState() => _AddVariationItemPageState();
}

class _AddVariationItemPageState extends State<AddVariationItemPage> {
  // Text editing controllers for the input fields
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController itemNameController = TextEditingController();
  late TextEditingController itemTypeController = TextEditingController();

  // Add controllers for new subItems
  late TextEditingController newSubItemDescriptionController =
      TextEditingController();
  late TextEditingController newSubItemUnitController = TextEditingController();
  late TextEditingController newSubItemNumberController =
      TextEditingController();
  late TextEditingController newSubItemUnitPriceController =
      TextEditingController();

  Quotation? quote;
  bool enabled = true;
  bool isAddingNewRow = false; // Added this line
  // List of items to be added to the Quote
  List<VariationSubItem> subItems = [];

  bool addingRow = true;

  List<String> units = ['m2', 'Unità', 'Corpo'];
  String? selectedUnit;

  // Method to handle adding a new item to the Quote
  void addSubItem(VariationSubItem item) {
    setState(() {
      subItems.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    subItems = widget.item?.subItems ?? [];
    enabled = widget.enabled;
    //subItems = widget.item?.subItems;
    nameController = TextEditingController(text: widget.item?.name ?? "");
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
          if (widget.enabled == true)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                VariationItem item = VariationItem(
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Sottolavorazione',
                                  style:
                                      Theme.of(context).textTheme.headlineSmall,
                                ),
                                ElevatedButton(
                                  child: const Text('Aggiungi'),
                                  onPressed: () {
                                    VariationSubItem newItem = VariationSubItem(
                                      description:
                                          newSubItemDescriptionController.text,
                                      unitType: selectedUnit ?? "m2",
                                      unitNumber: double.tryParse(
                                              newSubItemNumberController
                                                  .text) ??
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
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              controller: newSubItemDescriptionController,
                              decoration: const InputDecoration(
                                labelText: 'Description',
                              ),
                            ),
                            DropdownButtonFormField(
                              value: selectedUnit,
                              hint: const Text('Select unit'),
                              items: units.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                selectedUnit = newValue;
                              },
                              validator: (value) {
                                if (value == null) {
                                  return 'Please select a unit';
                                }
                                return null;
                              },
                            ),
                            if (selectedUnit != "Corpo")
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

  double computeTotal(List<VariationSubItem> subItems) {
    double total = 0;
    for (var subItem in subItems) {
      total += subItem.unitPrice * subItem.unitNumber;
    }
    return total;
  }

  Widget _buildSubItemRow(VariationSubItem subItem, int index) {
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
