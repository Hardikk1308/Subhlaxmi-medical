import 'package:mediecom/features/orders/domain/entities/order_entity.dart';

class OrdersModel extends OrderEntity {
  OrdersModel({
    super.f4Lcode,
    super.f4No,
    super.f4Party1,
    super.f4Gtot,
    super.f4Amt1,
    super.f4Amt2,
    super.f4Bt,
    super.f4Pm,
    super.f4Ps,
    super.f4Userdt,
    super.m2Chk1,
    super.m2Chk2,
    super.m2Chk7,
  });

  factory OrdersModel.fromJson(Map<String, dynamic> json) {
    return OrdersModel(
      f4Lcode: json['F4_LCODE']?.toString(),
      f4No: json['F4_NO']?.toString(),
      f4Party1: json['F4_PARTY1']?.toString(),
      f4Gtot: json['F4_GTOT']?.toString(),
      f4Amt1: json['F4_AMT1']?.toString(),
      f4Amt2: json['F4_AMT2']?.toString(),
      f4Bt: json['F4_BT']?.toString(),
      f4Pm: json['F4_PM']?.toString(),
      f4Ps: json['F4_PS']?.toString(),
      f4Userdt: json['F4_USERDT']?.toString(),
      m2Chk1: json['M2_CHK1']?.toString(),
      m2Chk7: json['M2_CHK7']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F4_LCODE': f4Lcode,
      'F4_NO': f4No,
      'F4_PARTY1': f4Party1,
      'F4_GTOT': f4Gtot,
      'F4_AMT1': f4Amt1,
      'F4_AMT2': f4Amt2,
      'F4_BT': f4Bt,
      'F4_PM': f4Pm,
      'F4_PS': f4Ps,
      'F4_USERDT': f4Userdt,
      'M2_CHK1': m2Chk1,
      'M2_CHK2': m2Chk2,
      'M2_CHK7': m2Chk7,
    };
  }
}
