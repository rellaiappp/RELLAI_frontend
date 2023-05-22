import 'package:flutter/material.dart';
import 'package:rellai_frontend/screens/professional/variation_item_page.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';
import 'package:rellai_frontend/widgets/variation_card.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/models/variation.dart';
import 'package:rellai_frontend/models/variation_item.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';

class AddVariationPage extends StatefulWidget {
  final String quoteId;
  final Variation? variation;
  final bool enabled;
  final bool showEditButton;
  const AddVariationPage(
      {Key? key,
      required this.quoteId,
      this.variation,
      this.enabled = true,
      this.showEditButton = false})
      : super(key: key);
  @override
  State<AddVariationPage> createState() => _AddVariationPageState();
}

class _AddVariationPageState extends State<AddVariationPage> {
  late TextEditingController variationNameController = TextEditingController();

  Variation? quote;
  bool enabled = true;
  List<VariationItem> variationItems = [];

  void addItem(VariationItem item) {
    setState(() {
      variationItems.add(item);
    });
  }

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
    if (widget.variation != null) {
      variationItems = widget.variation!.items;
    }

    variationNameController =
        TextEditingController(text: widget.variation?.name ?? '');
  }

  void submitVariation() async {
    if (variationItems.isNotEmpty) {
      final Variation newVariation = Variation(
          items: variationItems,
          name: variationNameController.text,
          quoteId: widget.quoteId);
      ProjectCRUD().createVariation(newVariation);
      print(newVariation.toJson());
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      projectProvider.updateCurrentProject();

      Navigator.pop(context);
    } else {
      const snackBar = SnackBar(
        content: Text('Non è stato aggiunto ancora nessuna lavorazione'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = computeTotal(variationItems);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Variazione'),
        actions: [
          if (enabled && widget.variation?.id == null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: submitVariation,
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      CustomTextField(
                          controller: variationNameController,
                          labelText: 'Nome variazione',
                          enabled: enabled),
                    ],
                  ),
                ),
                const SizedBox(height: 3),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: variationItems.length,
                  itemBuilder: (context, index) {
                    VariationItem item = variationItems[index];
                    return VariationItemCard(
                      item: item,
                      enabled: widget.variation == null ? true : false,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddVariationItemPage(
                                    item: item,
                                    enabled: enabled,
                                  )),
                        ).then((dynamic value) {
                          if (value != null && value is VariationItem) {
                            setState(() {
                              variationItems[index] = value;
                            });
                          }
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: enabled
          ? FloatingActionButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddVariationItemPage()),
                ).then((dynamic value) {
                  print("sono tornato nella'altra pagina");
                  print(value);
                  if (value != null && value is VariationItem) {
                    print(value.toJson());
                    addItem(value);
                  }
                });
              },
              child: const Icon(Icons.add),
            )
          : Container(),
      bottomNavigationBar: PriceBottomCard(
        showComplete: false,
        totalPrice: totalPrice,
      ),
    );
  }

  double computeTotal(List<VariationItem> items) {
    double total = 0;
    for (var item in items) {
      for (var subItem in item.subItems) {
        total += subItem.unitPrice * subItem.unitNumber;
      }
    }
    return total;
  }
}

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final TextInputType keyboardType;
  final bool enabled;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        // border: OutlineInputBorder(
        //   borderRadius: BorderRadius.circular(8.0),
        // ),
      ),
      keyboardType: keyboardType,
      enabled: enabled,
    );
  }
}
