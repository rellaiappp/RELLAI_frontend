import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/project.dart';

class AddItemPage extends StatefulWidget {
  final bool enabled;
  final Item? item;
  final int? index;
  final bool showEditButton;
  const AddItemPage(
      {Key? key,
      this.enabled = true,
      this.item,
      this.index,
      this.showEditButton = false})
      : super(key: key);
  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late TextEditingController _itemNameController;
  late TextEditingController _itemDescriptionController;
  late TextEditingController _itemUnitController;
  late TextEditingController _itemNumberController;
  late TextEditingController _itemUnitPriceController;
  TextEditingController _dropDownControllerText =
      TextEditingController(text: "");
  String? _itemType;
  bool enabled = true;
  int? index = null;

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;

    _itemNameController =
        TextEditingController(text: widget.item?.itemName ?? '');
    _itemDescriptionController =
        TextEditingController(text: widget.item?.itemDescription ?? '');
    _itemUnitController =
        TextEditingController(text: widget.item?.itemUnit ?? '');
    _itemNumberController = TextEditingController(
        text: widget.item != null ? widget.item!.itemNumber.toString() : '');
    _itemUnitPriceController = TextEditingController(
        text: widget.item != null ? widget.item!.itemUnitPrice.toString() : '');
    _dropDownControllerText = TextEditingController(
        text: widget.item != null ? widget.item!.itemType.toString() : '');

    if (widget.item != null) {
      _itemType = widget.item!.itemType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        actions: [
          if (widget.showEditButton && widget.item?.id == null)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  enabled = !enabled;
                });
              },
            ),
          if (enabled)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  Navigator.pop(
                    context,
                    Item(
                      itemName: _itemNameController.text,
                      itemType: _itemType!,
                      itemDescription: _itemDescriptionController.text,
                      itemUnit: _itemUnitController.text,
                      itemNumber: double.parse(_itemNumberController.text),
                      itemUnitPrice:
                          double.parse(_itemUnitPriceController.text),
                      itemCompletion: 0,
                    ),
                  );
                }
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _itemNameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item name';
                    }
                    return null;
                  },
                  enabled: enabled,
                ),
                enabled
                    ? DropdownButtonFormField<String>(
                        value: _itemType,
                        decoration:
                            const InputDecoration(labelText: 'Item Type'),
                        onChanged: !enabled
                            ? null
                            : (String? newValue) {
                                setState(() {
                                  _itemType = newValue;
                                });
                              },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select an item type';
                          }
                          return null;
                        },
                        items: <String>[
                          'Type 1',
                          'Type 2',
                          'Type 3',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      )
                    : TextFormField(
                        controller: _dropDownControllerText,
                        decoration:
                            const InputDecoration(labelText: 'Item Type'),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter an item type';
                          }
                          return null;
                        },
                        enabled: enabled,
                      ),
                TextFormField(
                  controller: _itemUnitController,
                  decoration: const InputDecoration(labelText: 'Item Unit'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item unit';
                    }
                    return null;
                  },
                  enabled: enabled,
                ),
                TextFormField(
                  controller: _itemNumberController,
                  decoration: const InputDecoration(labelText: 'Item Number'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item number';
                    }
                    return null;
                  },
                  enabled: enabled,
                ),
                TextFormField(
                  controller: _itemUnitPriceController,
                  decoration:
                      const InputDecoration(labelText: 'Item Unit Price'),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item unit price';
                    }
                    return null;
                  },
                  enabled: enabled,
                ),
                TextFormField(
                  controller: _itemDescriptionController,
                  maxLines: null,
                  decoration:
                      const InputDecoration(labelText: 'Item Description'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an item description';
                    }
                    return null;
                  },
                  enabled: enabled,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _itemNameController.dispose();
    _itemDescriptionController.dispose();
    _itemUnitController.dispose();
    _itemNumberController.dispose();
    _itemUnitPriceController.dispose();
    super.dispose();
  }
}
