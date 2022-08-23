class QrCodeModel {
  String id;
  String userId;
  int amount;
  DateTime createdAt;
  DateTime updatedAt;

  QrCodeModel({
    this.id,
    this.userId,
    this.updatedAt,
    this.createdAt,
    this.amount,
  });

  QrCodeModel.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    userId = json['userId'];
    amount = json['amount'];
    createdAt = json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null;
    updatedAt = json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null;
  }
}
