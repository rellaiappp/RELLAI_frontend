// import 'package:flutter/material.dart';
// import 'package:rellai_frontend/models/project.dart';
// import 'package:rellai_frontend/models/item.dart';
// import 'package:rellai_frontend/widgets/cost_summary_widget.dart';
// import 'package:uuid/uuid.dart';
// import 'package:rellai_frontend/widgets/price_card_bottom.dart';

// class AddItemPage extends StatefulWidget {
//   final bool enabled;
//   final Item? item;
//   final int? index;
//   final bool showEditButton;

//   const AddItemPage({
//     Key? key,
//     this.enabled = true,
//     this.item,
//     this.index,
//     this.showEditButton = false,
//   }) : super(key: key);

//   @override
//   _AddItemPageState createState() => _AddItemPageState();
// }

// class _AddItemPageState extends State<AddItemPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late TextEditingController _itemNameController;
//   late TextEditingController _itemDescriptionController;
//   late TextEditingController _itemNumberController;
//   late TextEditingController _itemUnitPriceController;
//   late TextEditingController _dropDownControllerText;
//   late TextEditingController _dropDownUnitControllerText;

//   String? _itemType;
//   String? _itemUnit;

//   String _itemNumberOfUnits = '';
//   String _itemUnitPrice = '';

//   bool enabled = true;
//   int? index = null;
//   double totalPrice = 0.0;
//   @override
//   void initState() {
//     super.initState();
//     enabled = widget.enabled;

//     _itemNameController =
//         TextEditingController(text: widget.item?.itemName ?? '');
//     _itemDescriptionController =
//         TextEditingController(text: widget.item?.itemDescription ?? '');
//     _itemNumberController = TextEditingController(
//         text: widget.item != null ? widget.item!.itemNumber.toString() : '');
//     _itemUnitPriceController = TextEditingController(
//         text: widget.item != null ? widget.item!.itemUnitPrice.toString() : '');
//     _dropDownControllerText = TextEditingController(
//         text: widget.item != null ? widget.item!.itemType.toString() : '');
//     _dropDownUnitControllerText = TextEditingController(
//         text: widget.item != null ? widget.item!.itemUnit.toString() : '');
//     _itemNumberOfUnits = _itemNumberController.text;
//     _itemUnitPrice = _itemUnitPriceController.text;
//     totalPrice = (double.tryParse(_itemNumberOfUnits) ?? 0.0) *
//         (double.tryParse(_itemUnitPrice) ?? 0.0);

//     _itemUnitPriceController.addListener(() {
//       setState(() {
//         _itemNumberOfUnits = _itemNumberController.text;
//         totalPrice = (double.tryParse(_itemNumberOfUnits) ?? 0.0) *
//             (double.tryParse(_itemUnitPrice) ?? 0.0);
//       });
//     });
//     _itemUnitPriceController.addListener(() {
//       setState(() {
//         _itemUnitPrice = _itemUnitPriceController.text;
//         totalPrice = (double.tryParse(_itemNumberOfUnits) ?? 0.0) *
//             (double.tryParse(_itemUnitPrice) ?? 0.0);
//       });
//     });

//     if (widget.item != null) {
//       _itemType = widget.item!.itemType;
//     }
//   }

//   @override
//   void dispose() {
//     _itemNameController.dispose();
//     _itemDescriptionController.dispose();
//     _itemNumberController.dispose();
//     _itemUnitPriceController.dispose();
//     _dropDownControllerText.dispose();
//     _dropDownUnitControllerText.dispose();
//     super.dispose();
//   }

//   void _handleItemTypeSelection(String? newValue) {
//     setState(() {
//       _itemType = newValue;
//     });
//   }

//   void _handleUnitSelection(String? newValue) {
//     setState(() {
//       _itemUnit = newValue;
//     });
//   }

//   void _handleSubmit() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.pop(
//         context,
//         Item(
//           id: const Uuid().v4(),
//           itemName: _itemNameController.text,
//           itemType: _itemType!,
//           itemDescription: _itemDescriptionController.text,
//           itemUnit: _itemUnit!,
//           itemNumber: double.parse(_itemNumberController.text),
//           itemUnitPrice: double.parse(_itemUnitPriceController.text),
//           itemCompletion: 0,
//         ),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Elementi'),
//         actions: [
//           if (widget.showEditButton && widget.item?.id == null)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 setState(() {
//                   enabled = !enabled;
//                 });
//               },
//             ),
//           if (enabled)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _handleSubmit,
//             ),
//         ],
//       ),
//       body: Stack(
//         //alignment: Alignment.bottomCenter,
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   enabled
//                       ? DropdownButtonFormField<String>(
//                           value: _itemType,
//                           decoration:
//                               const InputDecoration(labelText: 'Tipologia'),
//                           onChanged: !enabled ? null : _handleItemTypeSelection,
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Seleziona una tipologia';
//                             }
//                             return null;
//                           },
//                           items: <String>[
//                             'Type 1',
//                             'Type 2',
//                             'Type 3',
//                           ].map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         )
//                       : TextFormField(
//                           controller: _dropDownControllerText,
//                           decoration:
//                               const InputDecoration(labelText: 'Tipologia'),
//                           keyboardType: TextInputType.number,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return 'Inserisci una tipologia di elemento';
//                             }
//                             return null;
//                           },
//                           enabled: enabled,
//                         ),
//                   TextFormField(
//                     controller: _itemNameController,
//                     decoration: const InputDecoration(labelText: 'Nome'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserisci un nome';
//                       }
//                       return null;
//                     },
//                     enabled: enabled,
//                   ),
//                   enabled
//                       ? DropdownButtonFormField<String>(
//                           value: _itemUnit,
//                           decoration: const InputDecoration(
//                               labelText: 'Unità di misura'),
//                           onChanged: !enabled ? null : _handleUnitSelection,
//                           validator: (value) {
//                             if (value == null) {
//                               return 'Seleziona un unità di misura';
//                             }
//                             return null;
//                           },
//                           items: <String>[
//                             'Unità',
//                             'kg',
//                             'm2',
//                           ].map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                         )
//                       : TextFormField(
//                           controller: _dropDownUnitControllerText,
//                           decoration: const InputDecoration(
//                               labelText: 'Unità di misura'),
//                           keyboardType: TextInputType.text,
//                           validator: (value) {
//                             if (value == null || value.isEmpty) {
//                               return "Inserisci un'unità di misura";
//                             }
//                             return null;
//                           },
//                           enabled: enabled,
//                         ),
//                   TextFormField(
//                     controller: _itemNumberController,
//                     decoration: const InputDecoration(labelText: 'Item Number'),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Please enter an item number';
//                       }
//                       return null;
//                     },
//                     enabled: enabled,
//                   ),
//                   TextFormField(
//                     controller: _itemUnitPriceController,
//                     decoration:
//                         const InputDecoration(labelText: 'Prezzo unitario'),
//                     keyboardType: TextInputType.number,
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserisci un prezzo unitario';
//                       }
//                       return null;
//                     },
//                     enabled: enabled,
//                   ),
//                   TextFormField(
//                     controller: _itemDescriptionController,
//                     maxLines: null,
//                     decoration: const InputDecoration(labelText: 'Descrizione'),
//                     validator: (value) {
//                       if (value == null || value.isEmpty) {
//                         return 'Inserisci una descrizione';
//                       }
//                       return null;
//                     },
//                     enabled: enabled,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomAppBar(
//         child: PriceBottomCard(
//           totalPrice: totalPrice,
//         ),
//       ),
//     );
//   }
// }
