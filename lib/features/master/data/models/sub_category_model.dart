import 'package:mediecom/features/master/domain/entities/sub_category_entity.dart';

class SubcategoryModel extends SubcategoryEntity {
  const SubcategoryModel({
    super.m1Code,
    super.m1Name,
    super.m1Dc1,
    super.m1Bt,
    super.m1Group,
    super.categoryName,
  });

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) {
    return SubcategoryModel(
      m1Code: json['M1_CODE']?.toString(),
      m1Name: json['M1_NAME']?.toString(),
      m1Dc1: json['M1_DC1']?.toString(),
      m1Bt: json['M1_BT']?.toString(),
      m1Group: json['M1_GROUP']?.toString(),
      categoryName: json['category_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'M1_CODE': m1Code,
      'M1_NAME': m1Name,
      'M1_DC1': m1Dc1,
      'M1_BT': m1Bt,
      'M1_GROUP': m1Group,
      'category_name': categoryName,
    };
  }
}
