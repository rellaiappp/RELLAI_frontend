import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/item.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/models/variation.dart';
import 'package:rellai_frontend/screens/professional/item_v4_page.dart';
import 'package:rellai_frontend/widgets/price_card_bottom.dart';
import 'package:rellai_frontend/widgets/item_card.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/screens/professional/variation_page.dart';
import 'package:rellai_frontend/screens/professional/sal_screen.dart';
import 'package:rellai_frontend/models/sal.dart';
import 'package:provider/provider.dart';
import 'package:rellai_frontend/providers/project_provider.dart';

class AddQuotePage extends StatefulWidget {
  final String quoteType;
  final String projectId;
  final Quotation? quote;
  final bool enabled;
  final bool showEditButton;

  const AddQuotePage({
    Key? key,
    required this.quoteType,
    required this.projectId,
    this.quote,
    this.enabled = true,
    this.showEditButton = false,
  }) : super(key: key);

  @override
  State<AddQuotePage> createState() => _AddQuotePageState();
}

class _AddQuotePageState extends State<AddQuotePage>
    with TickerProviderStateMixin {
  late TextEditingController nameController = TextEditingController();
  late TextEditingController descriptionController = TextEditingController();
  late TextEditingController quoteNameController = TextEditingController();
  late TextEditingController quoteTypeController = TextEditingController();
  late TextEditingController quoteValidityController = TextEditingController();

  Quotation? quote;
  bool enabled = true;
  List<Item> items = [];
  TabController? _tabController;

  void addItem(Item item) {
    setState(() {
      items.add(item);
    });
  }

  double computeQuoteTotal(Quotation? quote) {
    double total = 0;
    if (quote == null) {
      return total;
    }
    for (final item in quote.items) {
      for (final subItem in item.subItems) {
        total += subItem.unitNumber * subItem.unitPrice;
      }
    }
    for (final variation in quote.variations) {
      for (final item in variation.items) {
        for (final subItem in item.subItems) {
          total += subItem.unitNumber * subItem.unitPrice;
        }
      }
    }
    return total;
  }

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;
    _tabController = TabController(length: 3, vsync: this);

    if (widget.quote != null) {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      quote = projectProvider.currentProject!.quotes
          .firstWhere((quote) => quote.id == widget.quote!.id);

      items = quote!.items;
    }

    nameController = TextEditingController(text: quote?.name ?? '');
    descriptionController =
        TextEditingController(text: quote?.description ?? '');
    quoteNameController = TextEditingController(text: quote?.name ?? '');
    quoteTypeController =
        TextEditingController(text: quote != null ? quote?.type : '');
    quoteValidityController =
        TextEditingController(text: quote != null ? quote?.name : '');
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void submitQuote() async {
    if (items.isNotEmpty) {
      final Quotation newQuote = Quotation(
          type: quoteTypeController.text,
          items: items,
          name: quoteNameController.text,
          description: descriptionController.text,
          status: 'created',
          accepted: false,
          rejected: false,
          projectId: widget.projectId,
          accessLevel: 'c');

      print(newQuote.toJson());
      await ProjectCRUD().createQuotation(newQuote, widget.projectId);
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      projectProvider.updateCurrentProject();
      Navigator.pop(context, newQuote);
    } else {
      const snackBar = SnackBar(
        content: Text('Non è stato aggiunto ancora nessuna lavorazione'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  void goToVariations() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => AddVariationPage(
                quoteId: widget.quote!.id!,
              )),
    );
  }

  void _showActionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Seleziona un'azione",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Add Variation button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddVariationPage(
                        quoteId: quote!.id!,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Nuova varaizione",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Add SAL button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SALScreen(
                        quotation: quote!,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    "Nuovo SAL",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final projectProvider = Provider.of<ProjectProvider>(context);
    if (projectProvider.currentProject!.quotes.isNotEmpty) {
      quote = projectProvider.currentProject!.quotes
          .firstWhere((quote) => quote.id == widget.quote!.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotazione'),
        actions: [
          if (!enabled &&
              quote!.accessLevel! != "client" &&
              quote!.accessLevel!.contains('c'))
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showActionDialog(context);
              },
            ),
          if (enabled && quote?.id == null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: submitQuote,
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          tabs: [
            const Tab(text: 'Dettagli'),
            if (quote != null && quote!.variations.isNotEmpty)
              const Tab(text: 'Variazioni'),
            if (quote != null && quote!.sals.isNotEmpty) const Tab(text: 'SAL'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildQuoteDetails(),
          if (quote != null && quote!.variations.isNotEmpty)
            _buildNewCardListTab(),
          if (quote != null && quote!.sals.isNotEmpty) _buildSALListTab(),
        ],
      ),
      floatingActionButton: _buildFloatingActionButton(),
      bottomNavigationBar: PriceBottomCard(
        showComplete: false,
        totalPrice: computeQuoteTotal(quote),
      ),
    );
  }

  Widget _buildQuoteDetails() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(
                controller: quoteNameController,
                labelText: 'Nome quotazione',
                enabled: enabled),
            CustomTextField(
                controller: quoteTypeController,
                labelText: 'Tipologia',
                enabled: enabled),
            CustomTextField(
                controller: nameController,
                labelText: 'Id interno',
                enabled: enabled),
            CustomTextField(
                controller: descriptionController,
                labelText: 'Descrizione',
                enabled: enabled),
            CustomTextField(
                controller: quoteValidityController,
                labelText: 'Validità (giorni)',
                enabled: enabled,
                keyboardType: TextInputType.number),
            const SizedBox(height: 30),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = items[index];
                return ItemCard(
                  item: item,
                  enabled: quote == null ? true : false,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              AddItemPage(item: item, enabled: enabled)),
                    ).then((dynamic value) {
                      if (value != null && value is Item) {
                        setState(() {
                          items[index] = value;
                        });
                      }
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNewCardListTab() {
    // Note: Replace 'Container()' with your actual new card list widget
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: quote?.variations.length,
        itemBuilder: (context, index) {
          Variation? item = quote?.variations[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Card(
              elevation: 5.0, // Shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AddVariationPage(
                          variation: item,
                          quoteId: quote!.id!,
                          enabled: false,
                          showEditButton: false,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item!.name,
                                  style: Theme.of(context).textTheme.titleLarge,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${item.items.length} variazioni",
                                  style: Theme.of(context).textTheme.bodyMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Totale',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '€${computeVariationTotal(item)}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      if (!item.accepted &&
                          !item.rejected &&
                          (quote!.accessLevel == "client"))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                item.accepted = true;
                                ProjectCRUD()
                                    .updateVariation(item.id!, accepted: true)
                                    .then((value) => setState(() {
                                          item.accepted = true;
                                        }));
                              },
                              child: const Text('Accetta'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                item.rejected = true;
                                ProjectCRUD()
                                    .updateVariation(item.id!, rejected: true)
                                    .then((value) => setState(() {
                                          item.rejected = true;
                                        }));
                              },
                              child: const Text('Rifiuta'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  double computeSalTotal(Sal? sal) {
    double total = 0;
    if (sal != null) {
      for (final item in sal.items) {}
    }
    return total;
  }

  Widget _buildSALListTab() {
    // Note: Replace 'Container()' with your actual new card list widget
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(16.0),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: quote?.sals.length,
        itemBuilder: (context, index) {
          Sal? item = quote?.sals[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Card(
              elevation: 5.0, // Shadow
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Container(
                padding: const EdgeInsets.all(18.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SALScreen(
                          quotation: quote!,
                          sal: item,
                          enabled: false,
                        ),
                      ),
                    );
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "SAL ${index + 1} ",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 4.0), // spacing
                              Text(
                                "Agg. ${item!.items.length}",
                                style: const TextStyle(fontSize: 16.0),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                'Totale',
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                '€${item.totalPrice}',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                      if (!item.accepted &&
                          !item.rejected &&
                          (quote!.accessLevel == "client"))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                item.accepted = true;
                                ProjectCRUD()
                                    .updateSal(item.id!, accepted: true)
                                    .then((value) => setState(() {
                                          item.accepted = true;
                                        }));
                              },
                              child: const Text('Accetta'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                item.rejected = true;
                                ProjectCRUD()
                                    .updateSal(item.id!, rejected: true)
                                    .then((value) => setState(() {
                                          item.rejected = true;
                                        }));
                              },
                              child: const Text('Rifiuta'),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    ));
  }

  Widget _buildFloatingActionButton() {
    return enabled
        ? FloatingActionButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddItemPage()),
              ).then((dynamic value) {
                if (value != null && value is Item) {
                  addItem(value);
                }
              });
            },
            child: const Icon(Icons.add),
          )
        : Container();
  }

  double computeTotal(List<Item> items) {
    double total = 0;
    for (var item in items) {
      for (var subItem in item.subItems) {
        total += subItem.unitPrice * subItem.unitNumber;
      }
    }
    return total;
  }
}

double computeVariationTotal(Variation variation) {
  double total = 0.0;
  for (int i = 0; i < variation.items.length; i++) {
    for (int j = 0; j < variation.items[i].subItems.length; j++) {
      total += variation.items[i].subItems[j].unitPrice *
          variation.items[i].subItems[j].unitNumber;
    }
  }
  return total;
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
      ),
      keyboardType: keyboardType,
      enabled: enabled,
    );
  }
}
