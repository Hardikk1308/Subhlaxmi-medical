import 'package:mediecom/features/master/domain/entities/slider_entity.dart';

class SliderModel extends SliderEntity {
  SliderModel({
    required super.m1Code,
    required super.m1Dc1,
    required super.m1Bt,
  });
  factory SliderModel.fromJson(Map<String, dynamic> json) {
    return SliderModel(
      m1Code: json['M1_CODE'] ?? '',
      m1Dc1: json['M1_DC1'] ?? '',
      m1Bt: json['M1_BT'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'M1_CODE': m1Code, 'M1_DC1': m1Dc1, 'M1_BT': m1Bt};
  }
}
