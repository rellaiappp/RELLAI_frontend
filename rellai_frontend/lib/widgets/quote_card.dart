import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rellai_frontend/models/quote.dart';
import 'package:rellai_frontend/screens/professional/quote_v2_page.dart';
import 'package:rellai_frontend/services/api/project.dart';
import 'package:rellai_frontend/providers/project_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:rellai_frontend/utils/confirm_dialog.dart';

class QuoteCard extends StatefulWidget {
  final Quotation quote;
  final String projectId;
  final VoidCallback loadProject;
  final String roleProject;

  const QuoteCard({
    Key? key,
    required this.quote,
    required this.projectId,
    required this.loadProject,
    required this.roleProject,
  }) : super(key: key);

  @override
  _QuoteCardState createState() => _QuoteCardState();
}

class _QuoteCardState extends State<QuoteCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    double price = widget.quote.items
        .expand((item) => item.subItems)
        .map((subItem) => subItem.unitNumber * subItem.unitPrice)
        .reduce((sum, price) => sum + price);

    for (var variation in widget.quote.variations) {
      price += variation.items
          .expand((item) => item.subItems)
          .map((subItem) => subItem.unitNumber * subItem.unitPrice)
          .reduce((sum, price) => sum + price);
    }

    final isAccepted = widget.quote.accepted;
    final isRejected = widget.quote.rejected;

    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.mediumImpact();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddQuotePage(
                  quote: widget.quote,
                  quoteType: widget.quote.type,
                  projectId: widget.projectId,
                  enabled: false,
                  showEditButton: false,
                ),
              ),
            );
          },
          child: Card(
            elevation: _isHovering ? 8.0 : 2.0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _isHovering ? Colors.blue : Colors.transparent,
                  width: 2.0,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // Quote Details
                    _buildQuoteDetails(theme, price, isAccepted, isRejected),

                    // Action Buttons for client role
                    if (widget.roleProject == 'client' &&
                        !isAccepted &&
                        !isRejected)
                      _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Extracting the Quote details widget for better readability
  Widget _buildQuoteDetails(
      ThemeData theme, double price, bool isAccepted, bool isRejected) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.quote.name,
                style: theme.textTheme.titleLarge,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                widget.quote.type,
                style: theme.textTheme.bodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isAccepted && !isRejected)
                    const Text(
                      'Da confermare',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange,
                      ),
                    ),
                  if (isRejected)
                    const Text(
                      'Rifiutata',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.red,
                      ),
                    ),
                ],
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
              NumberFormat.currency(symbol: '€').format(price),
              style: const TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Extracting the action buttons for better readability
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Tooltip(
            message: 'Accetta il preventivo',
            child: ElevatedButton(
              onPressed: () {
                ConfirmationDialog.show(
                  context: context,
                  title: "confermare l'invio del pagamento",
                  onConfirm: () {
                    ProjectCRUD().updateQuote(widget.quote.id!, accepted: true);
                    final projectProvider =
                        Provider.of<ProjectProvider>(context, listen: false);
                    projectProvider.updateCurrentProject();
                  },
                );
              },
              child: const Text('Accetta'),
            ),
          ),
          const SizedBox(width: 8.0),
          Tooltip(
            message: 'Rifiuta il preventivo',
            child: OutlinedButton(
              onPressed: () {
                ConfirmationDialog.show(
                  context: context,
                  title: "confermare l'invio del pagamento",
                  onConfirm: () {
                    ProjectCRUD().updateQuote(widget.quote.id!, rejected: true);
                    final projectProvider =
                        Provider.of<ProjectProvider>(context, listen: false);
                    projectProvider.updateCurrentProject();
                  },
                );
              },
              child: const Text('Rifiuta'),
            ),
          ),
        ],
      ),
    );
  }
}
