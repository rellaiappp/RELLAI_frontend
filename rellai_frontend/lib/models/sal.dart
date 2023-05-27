class Sal {
  String? id;
  String? name;
  String quoteId;
  DateTime? dateCreated;
  double completionLevel;
  bool accepted;
  bool rejected;
  List<SalSubItem> items; // List of SubItem objects
  double totalPrice;
  Sal(
      {this.id,
      this.name,
      required this.quoteId,
      this.accepted = false,
      this.rejected = false,
      this.dateCreated,
      this.items = const [],
      this.completionLevel = 0.0,
      required this.totalPrice});

  Sal.fromJson(Map<String, dynamic> json)
      : id = json['_id'] ?? '',
        name = json['name'] ?? '',
        quoteId = json['quoteId'] ?? '',
        accepted = json['accepted'],
        rejected = json['rejected'],
        totalPrice = double.tryParse(json['totalPrice'].toString()) ?? 0.0,
        completionLevel =
            double.tryParse(json['completionLevel'].toString()) ?? 0.0,
        dateCreated = DateTime.tryParse(json['dateCreated']),
        items = (json['items'] as List<dynamic>)
            .map((item) => SalSubItem.fromJson(item))
            .toList();

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'name': name,
      'completionLevel': completionLevel,
      'quoteId': quoteId,
      'accepted': accepted,
      'totalPrice': totalPrice,
      'rejected': rejected,
      'salSubItems': items.map((item) => item.toJson()).toList(),
    };
  }
}

class SalSubItem {
  String? id;
  String type;
  String itemName;
  String subItemId;
  String subItemName;
  double unitNumber;
  double unitPrice;
  double completionPercentage = 0.0;
  double completionPercentageAfter = 0.0;

  SalSubItem({
    this.id,
    required this.itemName,
    required this.type,
    required this.subItemId,
    required this.subItemName,
    required this.unitNumber,
    required this.unitPrice,
    required this.completionPercentage,
    required this.completionPercentageAfter,
  });

  SalSubItem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        itemName = json['itemName'] ?? '', // corrected property name
        subItemId = json['subItemId'] ?? '', // corrected property name
        subItemName = json['subItemName'] ?? '', // corrected property name
        type = json['type'] ?? '',
        unitNumber = double.tryParse(json['unitNumber'].toString()) ?? 0,
        unitPrice = double.tryParse(json['unitPrice'].toString()) ?? 0.0,
        completionPercentage =
            double.tryParse(json['completionPercentage'].toString()) ?? 0.0,
        completionPercentageAfter =
            double.tryParse(json['completionPercentageAfter'].toString()) ??
                0.0; // added completionPercentageAfter property

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'itemName': itemName,
      'subItemId': subItemId,
      'subItemName': subItemName,
      'type': type,
      'unitNumber': unitNumber,
      'unitPrice': unitPrice,
      'completionPercentage': completionPercentage,
      'completionPercentageAfter':
          completionPercentageAfter, // added completionPercentageAfter property
    };
  }
}
