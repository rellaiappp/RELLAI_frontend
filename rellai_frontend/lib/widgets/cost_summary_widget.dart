// cost_summary_widget.dart
import 'package:flutter/material.dart';

class CostSummaryWidget extends StatelessWidget {
  final double costo;
  final double iva;
  final double costoFinale;

  const CostSummaryWidget({
    Key? key,
    required this.costo,
    required this.iva,
    required this.costoFinale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: IntrinsicHeight(
        child: Padding(
          padding: EdgeInsets.only(
            left: 0.0,
            right: 0.0,
            bottom: MediaQuery.of(context).padding.bottom,
          ),
          child: Card(
            elevation: 4.0,
            margin: const EdgeInsets.all(0.0),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildRow('Costo', costo),
                  const Divider(),
                  _buildRow('IVA', iva),
                  const Divider(),
                  _buildRow('Costo Finale', costoFinale,
                      bold: true, fontSize: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, double value,
      {bool bold = false, double fontSize = 16.0}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: bold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)
                : const TextStyle(fontSize: 16.0),
          ),
          Text(
            value.toString(),
            style: bold
                ? const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0)
                : const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }
}
