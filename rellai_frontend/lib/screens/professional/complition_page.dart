import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/project.dart';
import 'package:rellai_frontend/services/api_service.dart';

class ComplitionPage extends StatefulWidget {
  final Quote quote;
  const ComplitionPage({super.key, required this.quote});

  @override
  State<ComplitionPage> createState() => _ComplitionPageState();
}

class _ComplitionPageState extends State<ComplitionPage> {
  final TextEditingController _noteController = TextEditingController();
  List<Item> _items = [];
  List<String> _photosUrls = [];

  @override
  void initState() {
    super.initState();
    setState(() {});
    ApiService().getQuote(widget.quote.id!).then((data) {
      if (data != null) {
        setState(() {
          _items = data.items!;
        });
      }
    });
  }

  void _updateCompletion(int index, double value) {
    setState(() {
      _items[index].itemCompletion = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Richiesta di avanzamento"),
        actions: [
          TextButton(
            onPressed: () {
              Quote newQuote = widget.quote!;
              newQuote.items = _items;
              ApiService().createCompletionRequest(CompletionRequest(
                  creatorId: newQuote.creatorId,
                  quote: newQuote,
                  quoteId: newQuote.id!,
                  projectId: newQuote.projectId,
                  note: _noteController.text,
                  images: _photosUrls,
                  accepted: false,
                  rejected: false));
              //Navigator.pop(context);
            },
            child: const Text(
              'Invia',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ListView.builder(
                itemCount: _items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _items[index].itemName,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(_items[index].itemDescription),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Column(
                              children: [
                                const Text('Completion'),
                                const SizedBox(height: 8),
                                TextFormField(
                                  initialValue:
                                      _items[index].itemCompletion.toString(),
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    _updateCompletion(
                                        index, double.tryParse(value) ?? 0);
                                  },
                                  validator: (value) {
                                    final int? parsedValue =
                                        int.tryParse(value ?? '');
                                    if (parsedValue == null ||
                                        parsedValue <
                                            widget.quote.items![index]
                                                .itemCompletion ||
                                        parsedValue > 100) {
                                      return 'Please enter a value between ${widget.quote.items![index].itemCompletion} and 100';
                                    }
                                    return null;
                                  },
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
              ),
              Container(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text('Notes'),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: TextFormField(
                        maxLines: 5,
                        controller: _noteController,
                        decoration: const InputDecoration(
                          hintText: 'Inserisci una nota qui',
                          border:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          focusedBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                          enabledBorder:
                              OutlineInputBorder(borderSide: BorderSide.none),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
