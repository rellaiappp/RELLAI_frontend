class VariationSubItem {
  String? id;
  String description;
  String? variationItemId;
  String unitType;
  double unitNumber;
  double unitPrice;
  double completionPercentage = 0.0;

  VariationSubItem({
    this.id,
    required this.description,
    this.variationItemId,
    required this.unitType,
    required this.unitNumber,
    required this.unitPrice,
  });

  VariationSubItem.fromJson(Map<String, dynamic> json)
      : id = json['_id'],
        description = json['description'] ?? '', // providing default value
        variationItemId = json['itemId'] ?? '',
        unitType = json['unitType'] ?? '',
        unitNumber = double.tryParse(json['unitNumber'].toString()) ?? 0,
        unitPrice = double.tryParse(json['unitPrice'].toString()) ?? 0.0,
        completionPercentage =
            double.tryParse(json['completionPercentage'].toString()) ?? 0.0;

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'description': description,
      if (variationItemId != null) 'itemId': variationItemId,
      'unitType': unitType,
      'unitNumber': unitNumber,
      'unitPrice': unitPrice,
      'completionPercentage': completionPercentage,
    };
  }
}
