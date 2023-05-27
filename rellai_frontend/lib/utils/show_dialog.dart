import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Future<void> showCustomDialog(BuildContext context, String title, String text,
    String buttonText, Function onSubmit) async {
  await showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        actionsAlignment: MainAxisAlignment.center,
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.asset('assets/confirmation.json', width: 100, height: 100),
            const SizedBox(height: 16.0),
            Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black54,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              onSubmit();
            },
            child: Text(
              buttonText,
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 18,
              ),
            ),
          ),
        ],
      );
    },
  );
}
