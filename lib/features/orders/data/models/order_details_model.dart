import 'package:mediecom/features/orders/domain/entities/order_details_entity.dart';

class OrderDetailsModel extends OrderDetailsEntity {
  const OrderDetailsModel({
    super.productCode,
    super.orderId,
    super.userId,
    super.grandTotal,
    super.amt1,
    super.amt2,
    super.bt,
    super.paymentMethod,
    super.ps,
    super.orderDate,
    super.customerName,
    super.customerContact,
    super.Address,
  });

  factory OrderDetailsModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailsModel(
      productCode: json['F4_LCODE']?.toString(),
      orderId: json['F4_NO']?.toString(),
      userId: json['F4_PARTY1']?.toString(),
      grandTotal: json['F4_GTOT']?.toString(),
      amt1: json['F4_AMT1']?.toString(),
      amt2: json['F4_AMT2']?.toString(),
      bt: json['F4_BT']?.toString(),
      paymentMethod: json['F4_PM']?.toString(),
      ps: json['F4_PS']?.toString(),
      orderDate: json['F4_USERDT']?.toString(),
      customerName: json['M2_CHK1']?.toString(),
      customerContact: json['M2_CHK2']?.toString(),
      Address: json['M2_CHK7']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F4_LCODE': productCode,
      'F4_NO': orderId,
      'F4_PARTY1': userId,
      'F4_GTOT': grandTotal,
      'F4_AMT1': amt1,
      'F4_AMT2': amt2,
      'F4_BT': bt,
      'F4_PM': paymentMethod,
      'F4_PS': ps,
      'F4_USERDT': orderDate,
      'M2_CHK1': customerName,
      'M2_CHK2': customerContact,
      'M2_CHK7': Address,
    };
  }

  /// Helper to parse a list of orders
  static List<OrderDetailsModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => OrderDetailsModel.fromJson(e)).toList();
  }
}
