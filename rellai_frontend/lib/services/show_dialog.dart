import 'package:flutter/material.dart';

Future<void> showCustomDialog(BuildContext context, String title, String text,
    IconData icon, String buttonText, Function onSubmit) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, size: 48),
            const SizedBox(height: 16.0),
            Text(text),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              onSubmit();
            },
            child: Text(buttonText),
          ),
        ],
      );
    },
  );
}
