// import 'package:flutter/material.dart';
// import 'package:rellai_frontend/models/project.dart';
// import 'package:rellai_frontend/models/item.dart';
// import 'package:rellai_frontend/models/quote.dart';
// import 'package:rellai_frontend/models/completion_request.dart';
// import 'package:rellai_frontend/services/crud/crudfirestore.dart';

// class ComplitionPage extends StatefulWidget {
//   final Quote quote;
//   const ComplitionPage({super.key, required this.quote});

//   @override
//   State<ComplitionPage> createState() => _ComplitionPageState();
// }

// class _ComplitionPageState extends State<ComplitionPage> {
//   final TextEditingController _noteController = TextEditingController();
//   List<Item> _items = [];
//   List<String> _photosUrls = [];

//   @override
//   void initState() {
//     super.initState();
//     setState(() {});
//     FirestoreCRUD().getProjectById(widget.quote.projectId).then((data) {
//       if (data != null) {
//         setState(() {
//           for (final q in data.quotations!) {
//             if (q.id == widget.quote.id) {
//               _items = q.items!;
//             }
//           }
//         });
//       }
//     });
//   }

//   void _updateCompletion(int index, double value) {
//     setState(() {
//       _items[index].itemCompletion = value;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Richiesta di avanzamento"),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Quote newQuote = widget.quote;
//               newQuote.items = _items;
//               ApiService().createCompletionRequest(CompletionRequest(
//                   creatorId: newQuote.creatorId,
//                   quote: newQuote,
//                   quoteId: newQuote.id!,
//                   projectId: newQuote.projectId,
//                   note: _noteController.text,
//                   images: _photosUrls,
//                   accepted: false,
//                   rejected: false));
//               Navigator.pop(context);
//             },
//             child: const Text(
//               'Invia',
//               style: TextStyle(color: Colors.white, fontSize: 16),
//             ),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 16),
//           child: Column(
//             children: [
//               ListView.builder(
//                 itemCount: _items.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Card(
//                     elevation: 4,
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                     shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(16)),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Row(
//                         children: [
//                           Expanded(
//                             flex: 3,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   _items[index].itemName,
//                                   style: const TextStyle(
//                                     fontSize: 18,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Text(
//                                   _items[index].itemName,
//                                   style: Theme.of(context).textTheme.caption!,
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Expanded(
//                             flex: 2,
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 const Text(
//                                   'Livello completamento',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 12,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 8),
//                                 Container(
//                                   decoration: BoxDecoration(
//                                     border: Border.all(
//                                       color: Colors.grey.withOpacity(0.5),
//                                       width: 1.0,
//                                     ),
//                                     borderRadius: BorderRadius.circular(5.0),
//                                   ),
//                                   child: TextFormField(
//                                     initialValue:
//                                         _items[index].itemCompletion.toString(),
//                                     keyboardType: TextInputType.number,
//                                     onChanged: (value) {
//                                       _updateCompletion(
//                                           index, double.tryParse(value) ?? 0);
//                                     },
//                                     validator: (value) {
//                                       final int? parsedValue =
//                                           int.tryParse(value ?? '');
//                                       if (parsedValue == null ||
//                                           parsedValue <
//                                               widget.quote.items![index]
//                                                   .itemCompletion ||
//                                           parsedValue > 100) {
//                                         return 'Please enter a value between ${widget.quote.items[index].itemCompletion} and 100';
//                                       }
//                                       return null;
//                                     },
//                                     decoration: const InputDecoration(
//                                       hintText: 'Livello di completamento',
//                                       border: InputBorder.none,
//                                       contentPadding: EdgeInsets.symmetric(
//                                           horizontal: 16.0),
//                                     ),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//                 shrinkWrap: true,
//                 physics: const NeverScrollableScrollPhysics(),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Note',
//                       style: TextStyle(
//                         fontWeight: FontWeight.normal,
//                         fontSize: 16,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Material(
//                       elevation: 1.0,
//                       borderRadius: BorderRadius.circular(4.0),
//                       child: TextFormField(
//                         maxLines: 5,
//                         controller: _noteController,
//                         decoration: const InputDecoration(
//                           hintText: 'Inserisci una nota qui',
//                           contentPadding: EdgeInsets.all(16.0),
//                           border: InputBorder.none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
