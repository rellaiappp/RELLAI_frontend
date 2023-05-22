import 'package:rellai_frontend/models/sub_item.dart';

class Item {
  String? id;
  String name;
  String? quoteId;
  List<SubItem> subItems; // List of SubItem objects

  Item({
    this.id,
    required this.name,
    this.quoteId,
    this.subItems = const [],
  });

  Item.fromJson(Map<String, dynamic> json)
      : id = json['_id'] ?? '',
        name = json['name'] ?? '',
        quoteId = json['quoteId'] ?? '',
        subItems = (json['subItems'] as List<dynamic>)
            .map((item) => SubItem.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      if (quoteId != null) 'quoteId': quoteId,
      'subItems': subItems.map((item) => item.toJson()).toList(),
    };
  }
}
