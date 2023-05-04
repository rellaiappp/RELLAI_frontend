import 'package:flutter/material.dart';
import 'input_widgets.dart';
import 'package:rellai_frontend/services/generate_fields.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class InfoForm extends StatefulWidget {
  final List<List> fields;
  final Function onSubmit;

  const InfoForm({super.key, required this.fields, required this.onSubmit});

  @override
  State<InfoForm> createState() => _InfoFormState();
}

class _InfoFormState extends State<InfoForm> {
  void _onSubmit(controllers, ids) {
    Map<String, dynamic> formData = {};

    for (int i = 0; i < widget.fields.length; i++) {
      String id = ids[i];
      String key = widget.fields[i][2];
      dynamic value = controllers[i] is TextEditingController
          ? controllers[i].text
          : controllers[i].value;
      formData[id] = value;
    }
    () {
      widget.onSubmit(formData);
    };
    // Handle form submission here, e.g., save data or send it to an API.
    Navigator.pop(context);
    print('Form submitted with data: $formData');
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> formFieldsAndControllers =
        generateFormFields(widget.fields, enabled: true);
    List<Widget> formFields = formFieldsAndControllers[0];
    List<dynamic> ids = formFieldsAndControllers[1];
    List<dynamic> controllers = formFieldsAndControllers[2];

    return Column(
      children: [
        ...formFields,
        const SizedBox(height: 20),
        SubmitButton(onPressed: () => _onSubmit(controllers, ids)),
      ],
    );
  }
}
