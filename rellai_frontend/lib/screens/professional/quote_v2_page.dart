import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/item.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/models/sub_item.dart';
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
import 'package:intl/intl.dart';
import 'package:rellai_frontend/models/invoice.dart';
import 'package:rellai_frontend/utils/confirm_dialog.dart';

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
  late TextEditingController quoteNameController = TextEditingController();
  late TextEditingController quoteDescriptionController =
      TextEditingController();
  late TextEditingController quoteInternalIdController =
      TextEditingController();
  late TextEditingController quoteTypeController = TextEditingController();
  late TextEditingController quoteValidityController = TextEditingController();

  Quotation? quote;
  bool enabled = true;
  List<Item> items = [];
  TabController? _tabController;

  bool _showAllFields = true;
  bool _quotationSent = false;

  void addItem(Item item) {
    setState(() {
      items.add(item);
    });
  }

  double computeQuoteTotal(Quotation? quote) {
    double total = 0;
    if (quote == null) {
      for (var item in items) {
        for (var subItem in item.subItems) {
          total += subItem.unitNumber * subItem.unitPrice;
        }
      }
    } else {
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
    }
    return total;
  }

  int getNumberOfTabs() {
    int i = 1;
    final projectProvider =
        Provider.of<ProjectProvider>(context, listen: false);
    if (widget.quote != null) {
      if (projectProvider.currentProject != null) {
        var _quote = projectProvider.currentProject!.quotes
            .firstWhere((quote) => quote.id == widget.quote!.id);
        if (_quote.variations.isNotEmpty) {
          i += 1;
        }
        if (_quote.sals.isNotEmpty) {
          i += 1;
        }
        if (_quote.invoices.isNotEmpty) {
          i += 1;
        }
      }
    }

    return i;
  }

  @override
  void initState() {
    super.initState();
    enabled = widget.enabled;

    if (widget.quote != null) {
      final projectProvider =
          Provider.of<ProjectProvider>(context, listen: false);
      quote = projectProvider.currentProject!.quotes
          .firstWhere((quote) => quote.id == widget.quote!.id);

      items = quote!.items;
      print(quote?.accessLevel);
      _tabController = TabController(length: getNumberOfTabs(), vsync: this);
    }

    quoteNameController = TextEditingController(text: quote?.name ?? '');
    quoteDescriptionController =
        TextEditingController(text: quote?.description ?? '');
    quoteInternalIdController = TextEditingController(text: quote?.name ?? '');
    quoteTypeController =
        TextEditingController(text: quote != null ? quote?.type : '');
    quoteValidityController =
        TextEditingController(text: quote != null ? quote?.name : '');
    _tabController = TabController(length: getNumberOfTabs(), vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void submitQuote() async {
    if (items.isNotEmpty) {
      final Quotation newQuote = Quotation(
          validity: quoteValidityController.text,
          internalId: quoteInternalIdController.text,
          type: quoteTypeController.text,
          items: items,
          name: quoteNameController.text,
          description: quoteDescriptionController.text,
          status: 'created',
          accepted: false,
          rejected: false,
          projectId: widget.projectId,
          accessLevel: 'c');

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
          // title: const Text(
          //   "Seleziona un'azione",
          //   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          // ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                alignment: Alignment.center,
                child: const Text(
                  "Seleziona un'azione",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
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
                    "Nuova variazione",
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
    try {
      if (projectProvider.currentProject!.quotes.isNotEmpty) {
        quote = projectProvider.currentProject!.quotes
            .firstWhere((quote) => quote.id == widget.quote!.id);
        _tabController = TabController(length: getNumberOfTabs(), vsync: this);
      }
    } catch (e) {
      print(e);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quotazione'),
        actions: [
          if (!enabled && quote!.accessLevel! == 'bc')
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _showActionDialog(context);
              },
            ),
          if (enabled && quote?.id == null)
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () {
                if (!_quotationSent) {
                  submitQuote();
                }
                setState(() {
                  _quotationSent = true;
                });
              },
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          isScrollable: true,
          tabs: [
            const Tab(text: 'Dettagli'),
            if (quote != null && quote!.variations.isNotEmpty)
              const Tab(text: 'Variazioni'),
            if (quote != null && quote!.sals.isNotEmpty) const Tab(text: 'SAL'),
            if (quote != null && quote!.invoices.isNotEmpty)
              const Tab(text: 'Richieste di pagamento')
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
          if (quote != null && quote!.invoices.isNotEmpty)
            _buildInvoiceListTab()
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
                enabled: _showAllFields ? enabled : false),
            if (_showAllFields)
              CustomTextField(
                  controller: quoteTypeController,
                  labelText: 'Tipologia',
                  enabled: enabled),
            if (_showAllFields)
              CustomTextField(
                  controller: quoteInternalIdController,
                  labelText: 'Id interno',
                  enabled: enabled),
            if (_showAllFields)
              CustomTextField(
                  controller: quoteDescriptionController,
                  labelText: 'Descrizione',
                  enabled: enabled),
            if (_showAllFields)
              CustomTextField(
                  controller: quoteValidityController,
                  labelText: 'Validità (giorni)',
                  enabled: enabled,
                  keyboardType: TextInputType.number),
            ListView.builder(
              shrinkWrap: true,
              itemCount: items.length,
              itemBuilder: (context, index) {
                Item item = items[index];
                return ItemCard(
                  item: item,
                  enabled: quote == null ? true : false,
                  onTap: () {
                    final projectProvider =
                        Provider.of<ProjectProvider>(context, listen: false);
                    projectProvider.updateCurrentProject();
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

  bool _areTextFieldsFilled() {
    return quoteNameController.text.isNotEmpty &&
        quoteTypeController.text.isNotEmpty &&
        quoteValidityController.text.isNotEmpty &&
        quoteDescriptionController.text.isNotEmpty &&
        quoteValidityController.text.isNotEmpty &&
        quoteInternalIdController.text.isNotEmpty;
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
              elevation: 2.0, // Shadow
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
                                NumberFormat.currency(symbol: '€')
                                    .format(computeVariationTotal(item)),
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
                                ConfirmationDialog.show(
                                  context: context,
                                  title: "accettare la variazione",
                                  onConfirm: () {
                                    item.accepted = true;
                                    ProjectCRUD()
                                        .updateVariation(item.id!,
                                            accepted: true)
                                        .then((value) => setState(() {
                                              item.accepted = true;
                                            }));
                                  },
                                );
                              },
                              child: const Text('Accetta'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                ConfirmationDialog.show(
                                  context: context,
                                  title: "rifiutare la variazione",
                                  onConfirm: () {
                                    item.accepted = true;
                                    ProjectCRUD()
                                        .updateVariation(item.id!,
                                            rejected: true)
                                        .then((value) => setState(() {
                                              _showAllFields = false;
                                              item.rejected = true;
                                            }));
                                  },
                                );
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
              elevation: 2.0, // Shadow
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
                                NumberFormat.currency(symbol: '€')
                                    .format(item.totalPrice),
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
                                ConfirmationDialog.show(
                                  context: context,
                                  title: "accettare il SAL",
                                  onConfirm: () {
                                    ProjectCRUD()
                                        .updateSal(item.id!, accepted: true)
                                        .then((value) => setState(() {
                                              item.accepted = true;
                                            }));
                                  },
                                );
                              },
                              child: const Text('Accetta'),
                            ),
                            const SizedBox(width: 8),
                            OutlinedButton(
                              onPressed: () {
                                ConfirmationDialog.show(
                                  context: context,
                                  title: "rifiutare il SAL",
                                  onConfirm: () {
                                    ProjectCRUD()
                                        .updateSal(item.id!, rejected: true)
                                        .then((value) => setState(() {
                                              item.rejected = true;
                                            }));
                                  },
                                );
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

  Widget _buildInvoiceListTab() {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: quote?.invoices.length,
      itemBuilder: (context, index) {
        Invoice? item = quote?.invoices[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          child: Card(
            elevation: 2.0, // Shadow
            child: Container(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Richiesta ${index + 1} ",
                              style: Theme.of(context).textTheme.titleLarge,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4.0), // spacing
                            Text(
                              "Agg. ${item!.id}",
                              style: const TextStyle(fontSize: 16.0),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text(
                              'Totale',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              NumberFormat.currency(symbol: '€')
                                  .format(item.amount),
                              style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
// Adds a line for separation
                  if (item.paid)
                    const Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Pagato',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  if (!item.accepted &&
                      !item.rejected &&
                      !item.paid &&
                      (quote!.accessLevel == "client"))
                    ButtonBar(
                      alignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ConfirmationDialog.show(
                              context: context,
                              title: "confermare l'invio del pagamento",
                              onConfirm: () {
                                ProjectCRUD()
                                    .updateInvoice(item.id!, accepted: true)
                                    .then((value) => setState(() {
                                          item.accepted = true;
                                        }));
                              },
                            );
                          },
                          child: const Text('Pagato'),
                        ),
                      ],
                    ),
                  if (!item.paid && (quote!.accessLevel == "bc"))
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            ConfirmationDialog.show(
                              context: context,
                              title: "confermare la ricezione del pagamento",
                              onConfirm: () {
                                ProjectCRUD()
                                    .updateInvoice(item.id!, paid: true)
                                    .then((value) => setState(() {
                                          item.paid = true;
                                        }));
                              },
                            );
                          },
                          child: const Text('Confermare ricezione pagamento'),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildFloatingActionButton() {
    return enabled
        ? FloatingActionButton(
            onPressed: () async {
              if (_areTextFieldsFilled()) {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AddItemPage()),
                ).then((dynamic value) {
                  if (value != null && value is Item) {
                    setState(() {
                      addItem(value);
                      _showAllFields = false;
                    });
                  }
                });
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Completa tutti i campi per preseguire'),
                  ),
                );
              }
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
    return Column(mainAxisAlignment: MainAxisAlignment.start, children: [
      TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: const OutlineInputBorder(),
        ),
        keyboardType: keyboardType,
        enabled: enabled,
      ),
      const SizedBox(
        height: 14,
      )
    ]);
  }
}
