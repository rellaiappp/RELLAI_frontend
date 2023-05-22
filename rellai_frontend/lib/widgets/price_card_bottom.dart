import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceBottomCard extends StatelessWidget {
  final double totalPrice;
  final bool showComplete;

  const PriceBottomCard({
    Key? key,
    required this.totalPrice,
    this.showComplete = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '€');

    return Material(
      elevation: 4.0,
      surfaceTintColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total',
                style: TextStyle(
                  fontSize: 20.0,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  currencyFormat.format(totalPrice),
                  style: const TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
