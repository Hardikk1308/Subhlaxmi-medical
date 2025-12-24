import 'package:mediecom/features/master/domain/entities/category_entity.dart';

class CategoryModel extends CategoryEntity {
  CategoryModel({
    required super.m1Code,
    required super.m1Name,
    required super.m1Bt,
    required super.m1dc1,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      m1Code: json['M1_CODE']?.toString() ?? '',
      m1Name: json['M1_NAME']?.toString() ?? '',

      // Old API: M1_BT
      // New API: M1_LNAME
      m1Bt: json['M1_BT']?.toString() ?? json['M1_LNAME']?.toString() ?? '',

      m1dc1: json['M1_DC1']?.toString() ?? '',
    );
  }
}
