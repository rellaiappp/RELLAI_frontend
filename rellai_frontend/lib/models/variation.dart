import 'package:rellai_frontend/models/variation_item.dart';

class Variation {
  String? id;
  String? type;
  String name;
  String? quoteId;
  DateTime? dateCreated;
  List<String> imageUrls;
  List<VariationItem> items;
  bool accepted = false;
  bool rejected = false;

  Variation({
    this.id,
    this.type,
    required this.name,
    this.quoteId,
    this.dateCreated,
    this.imageUrls = const [],
    this.items = const [],
    this.accepted = false,
    this.rejected = false,
  });

  Variation.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        type = json['type'],
        name = json['name'],
        quoteId = json['quote'],
        dateCreated = DateTime.tryParse(json['dateCreated']),
        imageUrls = json['imageUrls'] != null
            ? List<String>.from(json['imageUrls'])
            : [],
        accepted = json['accepted'] ?? false,
        rejected = json['rejected'] ?? false,
        items = json['items'] != null
            ? (json['items'] as List<dynamic>)
                .map((item) => VariationItem.fromJson(item))
                .toList()
            : [];

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'type': type,
      'name': name,
      'quoteId': quoteId,
      'accepted': accepted,
      'rejected': rejected,
      if (dateCreated != null) 'dateCreated': dateCreated?.toIso8601String(),
      'imageUrls': imageUrls,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
