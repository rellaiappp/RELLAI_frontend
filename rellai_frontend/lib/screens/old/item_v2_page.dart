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

//   Quote? quote;
//   bool enabled = true;
//   // List of items to be added to the Quote
//   List<SubItem> subItems = [];

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
//           if (widget.item?.id == null && widget.enabled == true)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: () {
//                 Item item = Item(
//                   id: Uuid().v4(),
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
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: itemNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Nome',
//                         ),
//                         enabled: enabled,
//                       ),
//                       // TextField(
//                       //   controller: itemTypeController,
//                       //   decoration: const InputDecoration(
//                       //     labelText: 'Tipologia',
//                       //   ),
//                       //   enabled: enabled,
//                       // ),
//                       // TextField(
//                       //   controller: descriptionController,
//                       //   decoration: const InputDecoration(
//                       //     labelText: 'Descrizione',
//                       //   ),
//                       //   enabled: enabled,
//                       // ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 // List of added items
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: subItems.length,
//                   itemBuilder: (context, index) {
//                     SubItem subItem = subItems[index];
//                     return InkWell(
//                       onTap: () {
//                         print(_totalPrice);
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AddSubItemPage(
//                               startingPrice: _totalPrice,
//                               subItem: subItem,
//                               index: index,
//                               showEditButton: true,
//                               enabled: false,
//                             ),
//                           ),
//                         );
//                       },
//                       child: Card(
//                         elevation: 4,
//                         margin: const EdgeInsets.symmetric(
//                             vertical: 3, horizontal: 16),
//                         shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(16)),
//                         child: Container(
//                           padding: const EdgeInsets.symmetric(
//                               vertical: 12, horizontal: 16),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Row(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Expanded(
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           subItem.subItemDescription,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline6!,
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           subItem.subItemUnit,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .caption!,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Row(
//                                     children: [
//                                       Text(
//                                         '\$${subItem.subItemNumber * subItem.subItemUnitPrice}',
//                                         style: Theme.of(context)
//                                             .textTheme
//                                             .headline6!,
//                                       ),
//                                       IconButton(
//                                         // Here is your new delete button
//                                         icon: Icon(Icons.delete),
//                                         onPressed: () {
//                                           setState(() {
//                                             subItems.removeAt(index);
//                                           });
//                                           // place your delete function here
//                                         },
//                                       ),
//                                     ],
//                                   )
//                                 ],
//                               ),
//                               const SizedBox(height: 2),
//                               const Divider(),
//                               const SizedBox(height: 2),
//                               Text(
//                                 'Clicca per maggiori dettagli',
//                                 style: Theme.of(context).textTheme.caption!,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//       //
//       // Button to add a new Item to the Quote

//       floatingActionButton: enabled
//           ? FloatingActionButton(
//               onPressed: () async {
//                 // Navigate to the controller to get a new Item
//                 SubItem newSubItem = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => AddSubItemPage(
//                               startingPrice: _totalPrice,
//                             )));
//                 if (newSubItem != null) {
//                   // Add the new Item to the Quote
//                   addSubItem(newSubItem);
//                 }
//                 // Add the new Item to the Quote
//               },
//               child: const Icon(Icons.add),
//             )
//           : Container(),

//       bottomNavigationBar: BottomAppBar(
//         child: PriceBottomCard(
//           totalPrice: _totalPrice,
//         ),
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
