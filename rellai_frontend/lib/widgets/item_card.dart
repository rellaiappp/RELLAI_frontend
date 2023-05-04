import 'package:flutter/material.dart';
import 'package:rellai_frontend/models/project.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(item.itemName,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(item.itemDescription),
            const SizedBox(height: 8),
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Inserisci valore',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                // Gestisci il cambiamento del valore dell'input qui
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
