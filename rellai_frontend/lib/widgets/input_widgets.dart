import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const CustomTextInput({
    Key? key,
    required this.label,
    required this.controller,
    required this.enabled,
  }) : super(key: key);

  @override
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  String? _validateInput(String? value) {
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          enabled: widget.enabled,
          decoration: InputDecoration(
            labelText: widget.label,
          ),
          controller: widget.controller,
          validator: _validateInput,
        ),
      ],
    );
  }
}

class CustomDateInput extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool enabled;

  const CustomDateInput(
      {super.key,
      required this.label,
      required this.controller,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
      ),
      controller: controller,
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now().add(const Duration(days: 3650)),
        );
        if (pickedDate != null) {
          controller.text = pickedDate.toString().split(' ')[0];
        }
      },
      readOnly: true,
    );
  }
}

class CustomSelectorInput extends StatelessWidget {
  final String label;
  final List<String> options;
  final ValueNotifier<String> selectedOption;
  final bool enabled;

  const CustomSelectorInput(
      {super.key,
      required this.label,
      required this.options,
      required this.selectedOption,
      required this.enabled});

  @override
  Widget build(BuildContext context) {
    return enabled
        ? DropdownButtonFormField(
            decoration: InputDecoration(
              labelText: label,
            ),
            value: selectedOption.value,
            items: options.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                selectedOption.value = newValue;
              }
            },
          )
        : Text(selectedOption.value);
  }
}

class SubmitButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SubmitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        textStyle: const TextStyle(fontSize: 16),
      ),
      child: const Text('Submit'),
    );
  }
}
