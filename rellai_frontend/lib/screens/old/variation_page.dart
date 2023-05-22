// import 'package:flutter/material.dart';
// import 'package:rellai_frontend/models/project.dart';
// import 'package:rellai_frontend/screens/professional/item_page.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:rellai_frontend/services/api_service.dart';
// import 'package:rellai_frontend/screens/professional/item_page.dart';
// import 'package:rellai_frontend/screens/professional/complition_page.dart';
// import 'package:rellai_frontend/models/quote.dart';
// import 'package:rellai_frontend/models/item.dart';
// import 'package:rellai_frontend/services/crud/crudfirestore.dart';
// import 'package:uuid/uuid.dart';

// class VariationPage extends StatefulWidget {
//   final String quoteType;
//   final String projectId;
//   final String quoteId;
//   final bool enabled;
//   final bool showEditButton;
//   const VariationPage(
//       {Key? key,
//       required this.quoteType,
//       required this.projectId,
//       required this.quoteId,
//       this.enabled = true,
//       this.showEditButton = false})
//       : super(key: key);
//   @override
//   State<VariationPage> createState() => _VariationPageState();
// }

// class _VariationPageState extends State<VariationPage> {
//   // Text editing controllers for the input fields
//   late TextEditingController nameController = TextEditingController();
//   late TextEditingController descriptionController = TextEditingController();
//   late TextEditingController quoteNameController = TextEditingController();
//   late TextEditingController quoteTypeController = TextEditingController();
//   late TextEditingController quoteValidityController = TextEditingController();

//   Quote? quote;
//   bool enabled = true;
//   // List of items to be added to the Quote
//   List<Item> items = [];

//   // Method to handle adding a new item to the Quote
//   void addItem(Item item) {
//     setState(() {
//       items.add(item);
//     });
//   }

//   String getTitle(String quoteType) {
//     if (quoteType == 'quotation') {
//       return 'quotazione';
//     } else if (quoteType == 'variation_order') {
//       return 'variazione';
//     } else {
//       return 'cambiamento';
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     enabled = widget.enabled;
//     nameController = TextEditingController(text: '');
//     descriptionController = TextEditingController(text: '');
//     quoteNameController = TextEditingController(text: '');
//     quoteTypeController = TextEditingController(text: '');
//     quoteValidityController = TextEditingController(text: '');
//   }

//   // Method to handle submitting the Quote
//   void submitVariation() async {
//     if (items.isNotEmpty) {
//       // Create a new Quote object with the input field values and added items
//       Quote newQuote = Quote(
//         id: const Uuid().v4(),
//         creatorId: FirebaseAuth.instance.currentUser!.uid,
//         quoteDescription: descriptionController.text,
//         projectId: widget.projectId,
//         quoteName: quoteNameController.text,
//         quoteType: widget.quoteType,
//         quoteValidity: quoteValidityController.text,
//         quoteStatus: 'created',
//         accepted: false,
//         items: items,
//       );

//       final result = await FirestoreCRUD()
//           .createVO(newQuote, widget.projectId, widget.quoteId);
//       // Submit the new Quote object to the backend here
//       //      Navigator.pop(context);
//       // Clear the input fields and added items list
//       setState(() {
//         nameController.clear();
//         descriptionController.clear();
//         quoteNameController.clear();
//         quoteTypeController.clear();
//         quoteValidityController.clear();
//         items = [];
//       });
//     } else {
//       const snackBar = SnackBar(
//         content: Text('Non è stato aggiunto ancora nessuno item'),
//       );
//       ScaffoldMessenger.of(context).showSnackBar(snackBar);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Crea ${getTitle(widget.quoteType)}'),
//         actions: [
//           if (widget.quoteId != null && widget.enabled == false)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: submitVariation,
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
//                         controller: nameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Name',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: descriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Description',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: quoteNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Quote Name',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: quoteTypeController,
//                         decoration: const InputDecoration(
//                           labelText: 'Quote Type',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: quoteValidityController,
//                         decoration: const InputDecoration(
//                           labelText: 'Quote Validity',
//                         ),
//                         enabled: enabled,
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 // List of added items
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     Item item = items[index];
//                     return Card(
//                       child: ListTile(
//                         title: Text(item.itemName),
//                         subtitle:
//                             Text("${item.itemUnitPrice * item.itemNumber}"),
//                         trailing: enabled
//                             ? GestureDetector(
//                                 onTap: () {
//                                   setState(() {
//                                     items.removeAt(index);
//                                   });
//                                 },
//                                 child: const Icon(Icons.delete),
//                               )
//                             : null,
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => AddItemPage(
//                                 item: item,
//                                 showEditButton: true,
//                                 enabled: false,
//                               ),
//                             ),
//                           );
//                         },
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
//                 Item newItem = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                         builder: (context) => const AddItemPage()));

//                 // Add the new Item to the Quote
//                 addItem(newItem);
//               },
//               child: const Icon(Icons.add),
//             )
//           : Container(),
//     );
//   }

//   double computeTotal(List<Item> items) {
//     double total = 0;
//     for (var item in items) {
//       total += item.itemUnitPrice * item.itemNumber;
//     }
//     return total;
//   }
// }
