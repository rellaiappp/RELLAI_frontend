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
// import 'package:rellai_frontend/screens/professional/variation_page.dart';
// import 'package:rellai_frontend/widgets/price_card_bottom.dart';

// class AddQuotePage extends StatefulWidget {
//   final String quoteType;
//   final String projectId;
//   final Quote? quote;
//   final bool enabled;
//   final bool showEditButton;
//   const AddQuotePage(
//       {Key? key,
//       required this.quoteType,
//       required this.projectId,
//       this.quote,
//       this.enabled = true,
//       this.showEditButton = false})
//       : super(key: key);
//   @override
//   State<AddQuotePage> createState() => _AddQuotePageState();
// }

// class _AddQuotePageState extends State<AddQuotePage> {
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
//     if (widget.quote != null) {
//       items = widget.quote!.items!;
//       FirestoreCRUD().getProjectById(widget.projectId).then((Project? project) {
//         if (project != null && project.quotations!.isNotEmpty) {
//           quote = project.quotations!
//               .firstWhere((element) => element.id == widget.quote!.id);
//           if (quote!.items!.isNotEmpty) {
//             items = quote!.items!;
//           }
//         }
//       });
//     }

//     nameController = TextEditingController(text: widget.quote?.quoteName ?? '');
//     descriptionController =
//         TextEditingController(text: widget.quote?.quoteDescription ?? '');
//     quoteNameController =
//         TextEditingController(text: widget.quote?.quoteName ?? '');
//     quoteTypeController = TextEditingController(
//         text: widget.quote != null ? widget.quote?.quoteType : '');
//     quoteValidityController = TextEditingController(
//         text: widget.quote != null ? widget.quote?.quoteValidity : '');
//   }

//   // Method to handle submitting the Quote
//   void submitQuote() async {
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

//       final result =
//           await FirestoreCRUD().createQuote(newQuote, widget.projectId);
//       print(result);
//       // Submit the new Quote object to the backend here
//       Navigator.pop(context);
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
//     double _totalPrice = 0;
//     for (var item in items) {
//       _totalPrice += item.itemUnitPrice * item.itemNumber;
//     }
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Crea ${getTitle(widget.quoteType)}'),
//         actions: [
//           if (widget.quote?.id != null &&
//               widget.enabled == false &&
//               widget.quote!.creatorId == FirebaseAuth.instance.currentUser!.uid)
//             PopupMenuButton<String>(
//               icon: const Icon(
//                 Icons.add,
//                 color: Colors.white,
//               ),
//               itemBuilder: (BuildContext context) => [
//                 const PopupMenuItem<String>(
//                   value: 'completion_request',
//                   child: Text('Richiesta di completamento'),
//                 ),
//                 const PopupMenuItem<String>(
//                   value: 'variation',
//                   child: Text('Variazione'),
//                 ),
//               ],
//               onSelected: (String value) {
//                 if (value == "variation") {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => VariationPage(
//                         quoteId: widget.quote!.id!,
//                         quoteType: "variation",
//                         projectId: widget.quote!.projectId,
//                       ),
//                     ),
//                   );
//                 } else if (value == "completion_request") {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ComplitionPage(
//                         quote: widget.quote!,
//                       ),
//                     ),
//                   );
//                 }
//               },
//             ),
//           if (widget.showEditButton)
//             IconButton(
//               icon: const Icon(Icons.edit),
//               onPressed: () {
//                 setState(() {
//                   enabled = !enabled;
//                 });
//               },
//             ),
//           if (enabled && widget.quote?.id == null)
//             IconButton(
//               icon: const Icon(Icons.check),
//               onPressed: submitQuote,
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
//                           labelText: 'Id interno',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: quoteTypeController,
//                         decoration: const InputDecoration(
//                           labelText: 'Tipologia',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: quoteNameController,
//                         decoration: const InputDecoration(
//                           labelText: 'Nome quotazione',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                         controller: descriptionController,
//                         decoration: const InputDecoration(
//                           labelText: 'Descrizione',
//                         ),
//                         enabled: enabled,
//                       ),
//                       TextField(
//                           controller: quoteValidityController,
//                           decoration: const InputDecoration(
//                             labelText: 'Validità (giorni)',
//                           ),
//                           enabled: enabled,
//                           keyboardType: TextInputType.number),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 3),
//                 // List of added items
//                 ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: items.length,
//                   itemBuilder: (context, index) {
//                     Item item = items[index];
//                     return InkWell(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => AddItemPage(
//                               item: item,
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
//                                           item.itemName,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .headline6!,
//                                         ),
//                                         const SizedBox(height: 4),
//                                         Text(
//                                           item.itemType,
//                                           style: Theme.of(context)
//                                               .textTheme
//                                               .caption!,
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                   Text(
//                                     '\$${item.itemUnitPrice * item.itemNumber}',
//                                     style:
//                                         Theme.of(context).textTheme.headline6!,
//                                   ),
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

//       bottomNavigationBar: BottomAppBar(
//         child: PriceBottomCard(
//           totalPrice: _totalPrice,
//         ),
//       ),
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
