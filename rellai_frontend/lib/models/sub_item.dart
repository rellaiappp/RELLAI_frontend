class SubItem {
  String? id;
  String description;
  String? itemId;
  String unitType;
  double unitNumber;
  double unitPrice;
  double completionPercentage = 0.0;

  SubItem({
    this.id,
    required this.description,
    this.itemId,
    required this.unitType,
    required this.unitNumber,
    required this.unitPrice,
  });

  SubItem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        description = json['description'] ?? '', // providing default value
        itemId = json['itemId'] ?? '',
        unitType = json['unitType'] ?? '',
        unitNumber = double.tryParse(json['unitNumber'].toString()) ?? 0,
        unitPrice = double.tryParse(json['unitPrice'].toString()) ?? 0.0,
        completionPercentage =
            double.tryParse(json['completionPercentage'].toString()) ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'description': description,
      if (itemId != null) 'itemId': itemId,
      'unitType': unitType,
      'unitNumber': unitNumber,
      'unitPrice': unitPrice,
      'completionPercentage': completionPercentage,
    };
  }
}
