import 'package:rellai_frontend/models/item.dart';
import 'package:rellai_frontend/models/variation.dart';
import 'package:rellai_frontend/models/sal.dart';
import 'package:rellai_frontend/models/invoice.dart';

class Quotation {
  String? id;
  String type;
  String name;
  String description;
  String projectId;
  String internalId;
  String? creatorId;
  String? validity;
  String status;
  bool accepted;
  bool rejected;
  DateTime? dateCreated;
  List<String> attachments;
  double price;
  String? accessLevel;
  List<Item> items;
  List<Variation> variations;
  List<Sal> sals;
  List<Invoice> invoices;
  // List of Item objects

  Quotation({
    this.id,
    required this.type,
    required this.name,
    required this.description,
    required this.projectId,
    required this.internalId,
    required this.validity,
    this.creatorId,
    required this.status,
    this.accepted = false,
    this.rejected = false,
    this.dateCreated,
    this.attachments = const [],
    this.price = 0.0,
    this.accessLevel,
    this.items = const [],
    this.variations = const [],
    this.sals = const [],
    this.invoices = const [],
  });

  Quotation.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        type = json['type'] ?? '',
        name = json['name'] ?? '',
        description = json['description'] ?? '',
        projectId = json['projectId'] ?? '',
        creatorId = json['creatorId'] ?? '',
        status = json['status'] ?? '',
        internalId = json['internalId'] ?? '',
        validity = json['validity'] ?? '',
        accepted = json['accepted'] ?? false,
        rejected = json['rejected'] ?? false,
        dateCreated =
            DateTime.parse(json['dateCreated'] ?? DateTime.now().toString()),
        attachments = List<String>.from(json['attachments'] ?? []),
        price = double.tryParse(json['price'].toString()) ?? 0.0,
        accessLevel = json['accessLevel'],
        items = (json['items'] as List<dynamic>)
            .map((item) => Item.fromJson(item))
            .toList(),
        variations = json['variations'] is List
            ? (json['variations'] as List)
                .where((item) => item != null)
                .map((item) => Variation.fromJson(item as Map<String, dynamic>))
                .toList()
            : [],
        sals = json['sals'] is List
            ? (json['sals'] as List)
                .where((item) => item != null)
                .map((item) => Sal.fromJson(item as Map<String, dynamic>))
                .toList()
            : [],
        invoices = json['invoices'] is List
            ? (json['invoices'] as List)
                .where((item) => item != null)
                .map((item) => Invoice.fromJson(item as Map<String, dynamic>))
                .toList()
            : [];

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'type': type,
      'name': name,
      'description': description,
      'projectId': projectId,
      'internalId': internalId,
      'validity': validity,
      'creatorId': creatorId,
      'status': status,
      'accepted': accepted,
      'rejected': rejected,
      if (id != null) 'dateCreated': dateCreated?.toIso8601String(),
      'attachments': attachments,
      'price': price,
      'accessLevel': accessLevel,
      'items': items.map((item) => item.toJson()).toList(),
      'variations': variations.map((item) => item.toJson()).toList(),
      'sals': sals.map((item) => item.toJson()).toList(),
      'invoices': invoices.map((item) => item.toJson()).toList(),
    };
  }
}
