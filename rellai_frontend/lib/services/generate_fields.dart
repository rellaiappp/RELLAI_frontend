import 'package:flutter/material.dart';
import 'package:rellai_frontend/widgets/input_widgets.dart';

List<dynamic> generateFormFields(inputFields, {required bool enabled}) {
  List<Widget> fields = [];
  List<String> ids = [];
  List<dynamic> controllers = [];

  for (var field in inputFields) {
    String id = field[0];
    String fieldType = field[1];
    TextEditingController controller = TextEditingController();

    switch (fieldType) {
      case "text":
        fields.add(CustomTextInput(
            label: field[2], controller: controller, enabled: enabled));
        controllers.add(controller);
        break;
      case "date":
        fields.add(CustomDateInput(
            label: field[2], controller: controller, enabled: enabled));
        controllers.add(controller);
        break;
      case "selector":
        ValueNotifier<String> selectedOption = ValueNotifier(field[3][0]);
        fields.add(CustomSelectorInput(
          label: field[2],
          options: field[3],
          selectedOption: selectedOption,
          enabled: enabled,
        ));
        controllers.add(selectedOption);
        break;
      default:
        break;
    }

    ids.add(id);
  }

  return [fields, ids, controllers];
}
