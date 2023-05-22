// import 'package:flutter/material.dart';
// import 'package:rellai_frontend/models/project.dart';
// import 'package:rellai_frontend/screens/professional/item_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rellai_frontend/screens/professional/item_page.dart';
// import 'package:rellai_frontend/screens/professional/complition_page.dart';
// import 'package:rellai_frontend/models/quote.dart';
// import 'package:rellai_frontend/models/item.dart';
// import 'package:rellai_frontend/models/sub_item.dart';
// import 'package:rellai_frontend/services/crud/crudfirestore.dart';
// import 'package:uuid/uuid.dart';
// import 'package:rellai_frontend/screens/professional/sub_item_page.dart';
// import 'package:rellai_frontend/screens/professional/variation_page.dart';
// import 'package:rellai_frontend/widgets/price_card_bottom.dart';

// class AddItemPage extends StatefulWidget {
//   final Item? item;
//   final int? index;
//   final bool enabled;
//   final bool showEditButton;
//   final String? creatorId;
//   const AddItemPage(
//       {Key? key,
//       this.item,
//       this.index,
//       this.enabled = true,
//       this.creatorId,
//       this.showEditButton = false})
//       : super(key: key);
//   @override
//   State<AddItemPage> createState() => _AddItemPageState();
// }

// class _AddItemPageState extends State<AddItemPage> {
//   // Text editing controllers for the input fields
//   late TextEditingController nameController = TextEditingController();
//   late TextEditingController descriptionController = TextEditingController();
//   late TextEditingController itemNameController = TextEditingController();
//   late TextEditingController itemTypeController = TextEditingController();

//   // Add controllers for new subItems
//   late TextEditingController newSubItemDescriptionController =
//       TextEditingController();
//   late TextEditingController newSubItemUnitController = TextEditingController();
//   late TextEditingController newSubItemNumberController =
//       TextEditingController();
//   late TextEditingController newSubItemUnitPriceController =
//       TextEditingController();

//   Quote? quote;
//   bool enabled = true;
//   bool isAddingNewRow = false; // Added this line
//   // List of items to be added to the Quote
//   List<SubItem> subItems = [];

//   bool addingRow = true;

//   List<String> units = ['m2', 'Unità', 'Corpo'];
//   String? selectedUnit;

//   // Method to handle adding a new item to the Quote
//   void addSubItem(SubItem item) {
//     setState(() {
//       subItems.add(item);
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     enabled = widget.enabled;
//     subItems = widget.item?.subItems ?? [];
//     nameController = TextEditingController(text: widget.item?.itemName ?? "");
//     itemTypeController =
//         TextEditingController(text: widget.item?.itemType ?? "");
//     print("eqresult");
//     print(widget.item?.id == null && widget.enabled == true);
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _totalPrice = 0;
//     for (var item in subItems) {
//       _totalPrice += item.subItemUnitPrice * item.subItemNumber;
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Lavorazione'),
//         actions: [
//           if (widget.enabled == true)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: () {
//                 Item item = Item(
//                   id: (widget.item != null) ? widget.item!.id! : Uuid().v4(),
//                   timestamp: DateTime.now().millisecondsSinceEpoch,
//                   itemName: nameController.text,
//                   itemType: itemTypeController.text,
//                   subItems: subItems,
//                   itemCompletion: 0.0,
//                 );
//                 Navigator.pop(context, item);
//               },
//             ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Stack(
//           children: [
//             Column(
//               children: [
//                 // Input fields for creating the Quote
//                 Container(
//                   padding: const EdgeInsets.all(10),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Nome',
//                         ),
//                         enabled: enabled,
//                       ),
//                       // other input fields
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 // List of added items
//                 LayoutBuilder(
//                   builder: (context, constraints) {
//                     final double maxWidth = constraints.maxWidth;
//                     return DataTable(
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey),
//                       ),
//                       columnSpacing: 0,
//                       columns: <DataColumn>[
//                         DataColumn(
//                           label: SizedBox(
//                             width: maxWidth * 0.05, // 10% of total width
//                             child: Text(
//                               '',
//                               style: TextStyle(fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: SizedBox(
//                             width: maxWidth * 0.25, // 40% of total width
//                             child: Text(
//                               'Description',
//                               style: TextStyle(fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: SizedBox(
//                             width: maxWidth * 0.25, // 15% of total width
//                             child: Text(
//                               'Unità',
//                               style: TextStyle(fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: SizedBox(
//                             width: maxWidth * 0.15, // 15% of total width
//                             child: Text(
//                               'N. Unità',
//                               style: TextStyle(fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: SizedBox(
//                             width: maxWidth * 0.15, // 15% of total width
//                             child: Text(
//                               'Prezzo',
//                               style: TextStyle(fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         ),
//                         DataColumn(
//                           label: SizedBox(
//                             width: maxWidth * 0.15, // 20% of total width
//                             child: Text(
//                               '',
//                               style: TextStyle(fontStyle: FontStyle.italic),
//                             ),
//                           ),
//                         ),
//                       ],
//                       rows: List<DataRow>.generate(
//                         isAddingNewRow ? subItems.length + 1 : subItems.length,
//                         (index) {
//                           if (isAddingNewRow && index == subItems.length) {
//                             return DataRow(
//                               cells: <DataCell>[
//                                 DataCell(Text((index + 1).toString())),
//                                 DataCell(TextFormField(
//                                     controller:
//                                         newSubItemDescriptionController)),
//                                 DataCell(
//                                   DropdownButtonFormField(
//                                     value: selectedUnit,
//                                     hint: const Text('Select unit'),
//                                     items: units.map((String value) {
//                                       return DropdownMenuItem<String>(
//                                         value: value,
//                                         child: Text(value),
//                                       );
//                                     }).toList(),
//                                     onChanged: (newValue) {
//                                       setState(() {
//                                         selectedUnit = newValue;
//                                       });
//                                     },
//                                     validator: (value) {
//                                       if (value == null) {
//                                         return 'Please select a unit';
//                                       }
//                                       return null;
//                                     },
//                                   ),
//                                 ),
//                                 DataCell((selectedUnit != "Corpo")
//                                     ? TextFormField(
//                                         controller: newSubItemNumberController)
//                                     : Container()),
//                                 DataCell(TextFormField(
//                                     controller: newSubItemUnitPriceController)),
//                                 DataCell(
//                                   IconButton(
//                                     icon: const Icon(Icons.check),
//                                     onPressed: () {
//                                       SubItem newItem = SubItem(
//                                           subItemDescription:
//                                               newSubItemDescriptionController
//                                                   .text,
//                                           subItemUnit: selectedUnit ?? "m2",
//                                           subItemNumber: double.tryParse(
//                                                   newSubItemNumberController
//                                                       .text) ??
//                                               1.0,
//                                           subItemUnitPrice: double.parse(
//                                             newSubItemUnitPriceController.text
//                                                 .replaceAll(',', '.')
//                                                 .replaceAll("'", ''),
//                                           ),
//                                           subItemCompletion: 0.0);
//                                       setState(() {
//                                         subItems.add(newItem);
//                                         isAddingNewRow = false;
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             );
//                           } else {
//                             return DataRow(
//                               cells: <DataCell>[
//                                 DataCell(Text((index + 1).toString())),
//                                 DataCell(
//                                     Text(subItems[index].subItemDescription)),
//                                 DataCell(Text(subItems[index].subItemUnit)),
//                                 DataCell(Text(
//                                     subItems[index].subItemNumber.toString())),
//                                 DataCell(Text(
//                                     '\€ ${subItems[index].subItemUnitPrice}')),
//                                 DataCell(
//                                   IconButton(
//                                     icon: Icon(Icons.delete),
//                                     onPressed: () {
//                                       setState(() {
//                                         subItems.removeAt(index);
//                                       });
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             );
//                           }
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//             // Align(
//             //   alignment: Alignment.bottomCenter,
//             //   child: Container(
//             //     padding: EdgeInsets.all(16.0),
//             //     color: Colors.grey[200],
//             //     child: PriceBottomCard(
//             //       totalPrice: _totalPrice,
//             //     ),
//             //   ),
//             // ),
//           ],
//         ),
//       ),

// // Modify the FloatingActionButton widget.
//       floatingActionButton: enabled
//           ? FloatingActionButton(
//               onPressed: () {
//                 setState(() {
//                   isAddingNewRow = true;
//                 });
//               },
//               child: const Icon(Icons.add),
//             )
//           : Container(),

//       bottomNavigationBar: PriceBottomCard(
//         totalPrice: _totalPrice,
//       ),
//     );
//   }

//   double computeTotal(List<SubItem> subItems) {
//     double total = 0;
//     for (var subItem in subItems) {
//       total += subItem.subItemUnitPrice * subItem.subItemNumber;
//     }
//     return total;
//   }
// }
