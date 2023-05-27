import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/item.dart';
import 'package:intl/intl.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final bool enabled;
  final VoidCallback? onTap;
  final Color? cardColor;

  const ItemCard({
    Key? key,
    required this.item,
    this.enabled = true,
    this.onTap,
    this.cardColor,
  }) : super(key: key);

  double computeItemTotal(Item item) {
    return item.subItems.fold(
        0, (total, subItem) => total + subItem.unitPrice * subItem.unitNumber);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: cardColor ?? Theme.of(context).cardColor,
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleLarge,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          "${item.subItems.length} lavorazioni",
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
                            .format(computeItemTotal(item)),
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
