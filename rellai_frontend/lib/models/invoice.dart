class Invoice {
  String? id;
  String senderId;
  String receiverId;
  String quoteId;
  String salId;
  DateTime dateCreated;
  int expiringDays;
  bool payed;
  bool paymentVerifies;
  double amount;
  bool accepted;
  bool paid;
  bool rejected;

  Invoice({
    this.id,
    required this.senderId,
    required this.receiverId,
    required this.quoteId,
    required this.salId,
    required this.dateCreated,
    required this.expiringDays,
    required this.payed,
    required this.paymentVerifies,
    required this.amount,
    required this.accepted,
    required this.paid,
    required this.rejected,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    return Invoice(
      id: json['_id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'] ?? '',
      quoteId: json['quoteId'],
      salId: json['salId'],
      dateCreated: DateTime.parse(json['dateCreated']),
      expiringDays: json['expiringDays'],
      payed: json['payed'],
      paymentVerifies: json['paymentVerifies'],
      amount: json['amount'],
      accepted: json['accepted'],
      paid: json['paid'],
      rejected: json['rejected'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'quoteId': quoteId,
      'salId': salId,
      'dateCreated': dateCreated.toIso8601String(),
      'expiringDays': expiringDays,
      'payed': payed,
      'paymentVerifies': paymentVerifies,
      'amount': amount,
      'accepted': accepted,
      'paid': paid,
      'rejected': rejected,
    };
  }
}
