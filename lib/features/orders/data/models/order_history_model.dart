import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/features/orders/domain/entities/order_history_entity.dart';

class OrderHistoryModel extends OrderHistoryEntity {
  const OrderHistoryModel({
    super.lCode,
    super.groupCode,
    super.party,
    super.party1,
    super.rate,
    super.amount,
    super.quantity,
    super.discount,
    super.discountAmt,
    super.total,
    super.orderDate,
    super.customerName,
    super.customerContact,
    super.productName,
    super.productLst,
    super.productCst,
    super.productIt,
    super.productVal,
    super.startDate,
    super.endDate,
    super.productImage,
  });

  factory OrderHistoryModel.fromJson(Map<String, dynamic> json) {
    // Try to get image from multiple possible fields
    String? imageUrl = json['M1_IMG']?.toString() ?? 
                       json['product_image']?.toString() ??
                       json['image']?.toString();
    
    // If no image URL, try to construct one from product code
    if ((imageUrl == null || imageUrl.isEmpty) && json['M1_CODE'] != null) {
      final productCode = json['M1_CODE'].toString();
      imageUrl = '${ApiConstants.productBase}$productCode.jpg';
    }

    return OrderHistoryModel(
      lCode: json['F4_LCODE']?.toString(),
      groupCode: json['F4_GR']?.toString(),
      party: json['F4_PARTY']?.toString(),
      party1: json['F4_PARTY1']?.toString(),
      rate: json['F4_RATE']?.toString(),
      amount: json['F4_AMT']?.toString(),
      quantity: json['F4_QTY']?.toString(),
      discount: json['F4_DIS']?.toString(),
      discountAmt: json['F4_DAMT']?.toString(),
      total: json['F4_ATOT']?.toString(),
      orderDate: json['F4_USERDT']?.toString(),
      customerName: json['M2_CHK1']?.toString(),
      customerContact: json['M2_CHK2']?.toString(),
      productName: json['M1_NAME']?.toString(),
      productLst: json['M1_LST']?.toString(),
      productCst: json['M1_CST']?.toString(),
      productIt: json['M1_IT']?.toString(),
      productVal: json['M1_VAL']?.toString(),
      startDate: json['M1_DT3']?.toString(),
      endDate: json['M1_DT4']?.toString(),
      productImage: imageUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F4_LCODE': lCode,
      'F4_GR': groupCode,
      'F4_PARTY': party,
      'F4_PARTY1': party1,
      'F4_RATE': rate,
      'F4_AMT': amount,
      'F4_QTY': quantity,
      'F4_DIS': discount,
      'F4_DAMT': discountAmt,
      'F4_ATOT': total,
      'F4_USERDT': orderDate,
      'M2_CHK1': customerName,
      'M2_CHK2': customerContact,
      'M1_NAME': productName,
      'M1_LST': productLst,
      'M1_CST': productCst,
      'M1_IT': productIt,
      'M1_VAL': productVal,
      'M1_DT3': startDate,
      'M1_DT4': endDate,
      'M1_IMG': productImage,
    };
  }

  /// Helper to parse a list of order items
  static List<OrderHistoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((e) => OrderHistoryModel.fromJson(e)).toList();
  }
}
