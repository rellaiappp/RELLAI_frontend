import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';
import 'package:rellai_frontend/models/sal.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/providers/project_provider.dart';

class SALScreen extends StatefulWidget {
  final Quotation? quotation;
  final bool? enabled;
  final Sal? sal;

  const SALScreen({
    Key? key,
    required this.quotation,
    this.enabled = true,
    this.sal,
  }) : super(key: key);

  @override
  _SALScreenState createState() => _SALScreenState();
}

class _SALScreenState extends State<SALScreen> {
  List<Map<String, dynamic>> _salItems = [];
  double completionLevel = 0.0;

  void _submitSAL(context) async {
    List<SalSubItem> salItems = [];
    for (var salItem in _salItems) {
      salItems.add(SalSubItem(
        type: salItem['type'],
        itemName: salItem['itemName'],
        subItemName: salItem['subItemName'],
        subItemId: salItem['subItemId'],
        unitNumber: salItem['unitNumber'],
        unitPrice: salItem['unitPrice'],
        completionPercentage: salItem['completionPercentage'],
        completionPercentageAfter: salItem['completionPercentageAfter'],
      ));
    }

    Sal sal = Sal(
      totalPrice: _computeTotal(_salItems),
      name: widget.quotation!.name,
      quoteId: widget.quotation!.id!,
      items: salItems,
      completionLevel: completionLevel,
    );
    await ProjectCRUD().createSal(sal);
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    projectProvider.updateCurrentProject();
    Navigator.pop(context);
  }

  List<Map<String, dynamic>> createSAL(Quotation quote) {
    List<Map<String, dynamic>> sal = [];
    for (var item in quote.items) {
      for (var subItem in item.subItems) {
        sal.add({
          'type': 'quote',
          'itemName': item.name,
          'subItemName': subItem.description,
          'unitNumber': subItem.unitNumber,
          'unitPrice': subItem.unitPrice,
          'subItemId': subItem.id,
          'completionPercentage': subItem.completionPercentage,
          'completionPercentageAfter': subItem.completionPercentage,
        });
      }
    }

    for (var variation in quote.variations) {
      for (var item in variation.items) {
        for (var subItem in item.subItems) {
          sal.add({
            'type': 'variation',
            'itemName': item.name,
            'subItemName': subItem.description,
            'unitNumber': subItem.unitNumber,
            'unitPrice': subItem.unitPrice,
            'subItemId': subItem.id,
            'completionPercentage': subItem.completionPercentage,
            'completionPercentageAfter': subItem.completionPercentage,
          });
        }
      }
    }

    return sal;
  }

  List<Map<String, dynamic>> _loadSal(Sal sal) {
    List<Map<String, dynamic>> newSal = [];
    for (var salItem in sal.items) {
      newSal.add({
        'type': salItem.type,
        'itemName': salItem.itemName,
        'subItemName': salItem.subItemName,
        'unitNumber': salItem.unitNumber,
        'unitPrice': salItem.unitPrice,
        'subItemId': salItem.subItemId,
        'completionPercentage': salItem.completionPercentage,
        'completionPercentageAfter': salItem.completionPercentageAfter,
      });
    }

    return newSal;
  }

  double _computeTotal(List<Map<String, dynamic>> sals) {
    double total = 0.0;
    for (var sal in sals) {
      total += (sal['unitNumber'] * sal['unitPrice']) * (completionLevel) / 100;
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    _salItems = createSAL(widget.quotation!);
    if (widget.sal != null) {
      setState(() {
        _salItems = _loadSal(widget.sal!);
        completionLevel = widget.sal!.completionLevel;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SAL'),
        actions: [
          if (widget.enabled!)
            IconButton(
              onPressed: () {
                _submitSAL(context);
              },
              icon: const Icon(Icons.check),
            ),
        ],
      ),
      body: ListView.builder(
        itemCount: _salItems.length,
        itemBuilder: (BuildContext context, int index) {
          var salItem = _salItems[index];

          return Card(
            elevation: 1.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 5.0,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).hoverColor,
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Text(
                            salItem['type'] == 'quote'
                                ? 'Quotazione'
                                : 'Variazione',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                        Text(
                          salItem['itemName'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          salItem['subItemName'],
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: '% Compl.',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        suffixIcon: Icon(
                          Icons.percent,
                          color: Colors.grey[600],
                        ),
                        fillColor: Colors.blue[60],
                        filled: true,
                      ),
                      initialValue: (_salItems[index]['completionPercentage'] ==
                              _salItems[index]['completionPercentageAfter'])
                          ? _salItems[index]['completionPercentage'].toString()
                          : _salItems[index]['completionPercentageAfter']
                              .toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (double.tryParse(value) != null) {
                            _salItems[index]['completionPercentageAfter'] =
                                double.tryParse(value);
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: Container(
        height: 220,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Divider(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  const Expanded(
                    child: ListTile(
                      title: Text("Livello completamento richiesto"),
                    ),
                  ),
                  SizedBox(
                    width: 100,
                    child: TextFormField(
                      enabled: widget.enabled,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 6.0, vertical: 8.0),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        labelText: '% Compl.',
                        labelStyle: TextStyle(color: Colors.grey[600]),
                        suffixIcon: Icon(
                          Icons.percent,
                          color: Colors.grey[600],
                        ),
                        fillColor: Colors.blue[60],
                        filled: true,
                      ),
                      initialValue: completionLevel.toString(),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          if (double.tryParse(value) != null) {
                            completionLevel = double.tryParse(value) ?? 0.0;
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            PriceBottomCard(
              totalPrice: _computeTotal(_salItems),
              showComplete: false,
            ),
          ],
        ),
      ),
    );
  }
}
