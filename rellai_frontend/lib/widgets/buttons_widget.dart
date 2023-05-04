import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final bool isEnabled;
  final String buttonText; // Add the buttonText parameter
  final VoidCallback? onPressed; // Add the onPressedFunction parameter

  const PrimaryButton({
    Key? key,
    this.isEnabled = true,
    required this.buttonText, // Make the buttonText required
    this.onPressed, // Make the onPressedFunction optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 16));
    return Container(
      padding: const EdgeInsets.all(24.0),
      child: ElevatedButton(
        style: style,
        onPressed: isEnabled ? onPressed : null,
        child: Text(buttonText), // Use the buttonText parameter
      ),
    );
  }
}
