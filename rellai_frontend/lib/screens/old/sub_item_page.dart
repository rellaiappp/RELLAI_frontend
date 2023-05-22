// import 'package:flutter/material.dart';
// import 'package:rellai_frontend/models/sub_item.dart';
// import 'package:uuid/uuid.dart';
// import 'package:rellai_frontend/widgets/price_card_bottom.dart';

// class AddSubItemPage extends StatefulWidget {
//   final bool enabled;
//   final SubItem? subItem;
//   final int? index;
//   final bool showEditButton;
//   final double? startingPrice;

//   const AddSubItemPage({
//     Key? key,
//     this.enabled = true,
//     this.subItem,
//     this.index,
//     this.startingPrice,
//     this.showEditButton = false,
//   }) : super(key: key);

//   @override
//   State<AddSubItemPage> createState() => _AddSubItemPageState();
// }

// class _AddSubItemPageState extends State<AddSubItemPage> {
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late TextEditingController _descriptionController;
//   late TextEditingController _numberController;
//   late TextEditingController _unitPriceController;
//   late TextEditingController _unitController;
//   String _unit = 'm2';
//   String _numberOfUnits = '';
//   String _unitPrice = '';
//   bool isEnabled = true;
//   double totalPrice = 0.0;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.startingPrice != null) {
//       print("Il prezzo è ${widget.startingPrice}");
//       if (widget.subItem == null) {
//         totalPrice += widget.startingPrice!;
//       }
//     }
//     isEnabled = widget.enabled;

//     _descriptionController =
//         TextEditingController(text: widget.subItem?.subItemDescription ?? '');
//     _numberController = TextEditingController(
//         text: widget.subItem != null
//             ? widget.subItem!.subItemNumber.toString()
//             : '');
//     _unitPriceController = TextEditingController(
//         text: widget.subItem != null
//             ? widget.subItem!.subItemUnitPrice.toString()
//             : '');
//     _unitController = TextEditingController(
//         text: widget.subItem != null
//             ? widget.subItem!.subItemUnit.toString()
//             : '');
//     _numberOfUnits = _numberController.text;
//     _unitPrice = _unitPriceController.text;
//     _calculateTotalPrice();

//     _unitPriceController.addListener(_calculateTotalPrice);
//     _numberController.addListener(_calculateTotalPrice);
//   }

//   @override
//   void dispose() {
//     _descriptionController.dispose();
//     _numberController.dispose();
//     _unitPriceController.dispose();
//     _unitController.dispose();
//     super.dispose();
//   }

//   void _handleUnitSelection(String? newValue) {
//     setState(() {
//       _unit = newValue!;
//       if (newValue == "Corpo") {
//         _numberController.text = "1";
//       }
//     });
//   }

//   void _calculateTotalPrice() {
//     setState(() {
//       _numberOfUnits = _numberController.text;
//       _unitPrice = _unitPriceController.text;
//       totalPrice = totalPrice += (double.tryParse(_numberOfUnits) ?? 0.0) *
//           (double.tryParse(_unitPrice) ?? 0.0);
//     });
//   }

//   void _handleSubmit() {
//     if (_formKey.currentState!.validate()) {
//       Navigator.pop(
//         context,
//         SubItem(
//           id: const Uuid().v4(),
//           subItemDescription: _descriptionController.text,
//           subItemUnit: _unit,
//           subItemNumber: double.parse(_numberController.text),
//           subItemUnitPrice: double.parse(_unitPriceController.text),
//           subItemCompletion: 0,
//         ),
//       );
//     }
//   }

//   String? _validateNotEmpty(String? value) {
//     if (value == null || value.isEmpty) {
//       return 'Please fill this field';
//     }
//     return null;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Elementi'),
//         actions: [
//           if (widget.showEditButton && widget.subItem?.id == null)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 setState(() {
//                   isEnabled = !isEnabled;
//                 });
//               },
//             ),
//           if (isEnabled)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: _handleSubmit,
//             ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 children: [
//                   _unitDropdown(),
//                   _unit != "Corpo" ? _numberField() : Container(),
//                   _unitPriceField(),
//                   _descriptionField(),
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

//   DropdownButtonFormField<String> _unitDropdown() {
//     return DropdownButtonFormField<String>(
//       value: _unit,
//       decoration: const InputDecoration(labelText: 'Unità di misura'),
//       onChanged: !isEnabled ? null : _handleUnitSelection,
//       validator: _validateNotEmpty,
//       items: <String>[
//         'Unità',
//         'kg',
//         'm2',
//         'Corpo',
//       ].map<DropdownMenuItem<String>>((String value) {
//         return DropdownMenuItem<String>(
//           value: value,
//           child: Text(value),
//         );
//       }).toList(),
//     );
//   }

//   TextFormField _numberField() {
//     return TextFormField(
//       controller: _numberController,
//       decoration: const InputDecoration(labelText: 'Item Number'),
//       keyboardType: TextInputType.number,
//       validator: _validateNotEmpty,
//       enabled: isEnabled,
//     );
//   }

//   TextFormField _unitPriceField() {
//     return TextFormField(
//       controller: _unitPriceController,
//       decoration: InputDecoration(
//           labelText: (_unit == "Corpo") ? 'Prezzo' : 'Prezzo unitario'),
//       keyboardType: TextInputType.number,
//       validator: _validateNotEmpty,
//       enabled: isEnabled,
//     );
//   }

//   TextFormField _descriptionField() {
//     return TextFormField(
//       controller: _descriptionController,
//       maxLines: null,
//       decoration: const InputDecoration(labelText: 'Descrizione'),
//       validator: _validateNotEmpty,
//       enabled: isEnabled,
//     );
//   }
// }
