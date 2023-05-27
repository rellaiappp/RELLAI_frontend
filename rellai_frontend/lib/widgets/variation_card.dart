import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/variation_item.dart';
import 'package:intl/intl.dart';

class VariationItemCard extends StatelessWidget {
  final VariationItem item;
  final bool enabled;
  final VoidCallback? onTap;
  final Color? cardColor;

  const VariationItemCard({
    Key? key,
    required this.item,
    this.enabled = true,
    this.onTap,
    this.cardColor,
  }) : super(key: key);

  double computeItemTotal(VariationItem item) {
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
        margin: const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
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
                      ],
                    ),
                  ),
                  Text(
                    NumberFormat.currency(symbol: '€')
                        .format(computeItemTotal(item)),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
