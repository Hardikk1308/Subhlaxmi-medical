import 'package:equatable/equatable.dart';

class ProductEntity extends Equatable {
  final String? M1_CODE;
  final String? M1_NAME;
  final String? M1_LNAME;
  final String? M1_LST;
  final String? M1_CST;
  final String? M1_IT;
  final String? M1_VAL;
  final String? M1_AMT1;
  final String? M1_AMT2;
  final String? M1_DT1;
  final String? M1_DT2;
  final String? M1_DT3;
  final String? M1_DT4;
  final String? M1_BT;
  final String? M1_ADD1;
  final String? M1_ADD2;
  final String? M1_GROUP;
  final String? M1_PRINT;
  final String? category_name;
  final String? category_id;
  final String? subcategory_name;
  final List<String> image;
  int quantity;

  ProductEntity({
    this.M1_CODE,
    this.M1_NAME,
    this.M1_LNAME,
    this.M1_LST,
    this.M1_CST,
    this.M1_IT,
    this.M1_VAL,
    this.M1_AMT1,
    this.M1_AMT2,
    this.M1_DT1,
    this.M1_DT2,
    this.M1_DT3,
    this.M1_DT4,
    this.M1_BT,
    this.M1_ADD1,
    this.M1_ADD2,
    this.M1_GROUP,
    this.M1_PRINT,
    this.category_name,
    this.category_id,
    this.subcategory_name,
    this.image = const [],
    this.quantity = 1,
  });

  @override
  List<Object?> get props => [
    M1_CODE,
    M1_NAME,
    M1_LNAME,
    M1_LST,
    M1_CST,
    M1_IT,
    M1_VAL,
    M1_AMT1,
    M1_AMT2,
    M1_DT1,
    M1_DT2,
    M1_DT3,
    M1_DT4,
    M1_BT,
    M1_ADD1,
    M1_ADD2,
    M1_GROUP,
    M1_PRINT,
    category_name,
    category_id,
    subcategory_name,
    image,
  ];

  copyWith({required M1_AMT2}) {}
}
