import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class CartItemModel extends HiveObject {
  @HiveField(0)
  String productCode;

  @HiveField(1)
  int quantity;

  @HiveField(2)
  DateTime addedAt;

  CartItemModel({
    required this.productCode,
    required this.quantity,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'productCode': productCode,
    'quantity': quantity,
    'addedAt': addedAt.toIso8601String(),
  };

  factory CartItemModel.fromJson(Map<String, dynamic> json) => CartItemModel(
    productCode: json['productCode'],
    quantity: json['quantity'],
    addedAt: DateTime.parse(json['addedAt']),
  );
}
