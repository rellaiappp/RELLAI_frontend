import 'package:rellai_frontend/models/variation_sub_item.dart';

class VariationItem {
  String? id;
  String name;
  String? variationId;
  List<VariationSubItem> subItems;

  VariationItem({
    this.id,
    required this.name,
    this.variationId,
    this.subItems = const [],
  });

  VariationItem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        name = json['name'],
        variationId = json['quoteId'],
        subItems = (json['subItems'] as List<dynamic>)
            .map((item) => VariationSubItem.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      if (variationId != null) 'quoteId': variationId,
      'subItems': subItems.map((item) => item.toJson()).toList(),
    };
  }
}
