import 'package:flutter/material.dart';

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final VoidCallback onConfirm;

  const ConfirmationDialog({
    required this.title,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.headline6,
      ),
      content: Text(
        "Are you sure you want to $title?",
        style: Theme.of(context).textTheme.bodyText1,
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            "Cancel",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            "Confirm",
            style: Theme.of(context).textTheme.bodyText1,
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  static Future<void> show(
      {required BuildContext context,
      required String title,
      required VoidCallback onConfirm,
      VoidCallback? onDecline}) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return ConfirmationDialog(
          title: title,
          onConfirm: onConfirm,
        );
      },
    );
  }
}
