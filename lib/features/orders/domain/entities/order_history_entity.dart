import 'package:equatable/equatable.dart';

class OrderHistoryEntity extends Equatable {
  final String? lCode; // F4_LCODE
  final String? groupCode; // F4_GR
  final String? party; // F4_PARTY
  final String? party1; // F4_PARTY1
  final String? rate; // F4_RATE
  final String? amount; // F4_AMT
  final String? quantity; // F4_QTY
  final String? discount; // F4_DIS
  final String? discountAmt; // F4_DAMT
  final String? total; // F4_ATOT
  final String? orderDate; // F4_USERDT
  final String? customerName; // M2_CHK1
  final String? customerContact; // M2_CHK2
  final String? productName; // M1_NAME
  final String? productLst; // M1_LST
  final String? productCst; // M1_CST
  final String? productIt; // M1_IT
  final String? productVal; // M1_VAL
  final String? startDate; // M1_DT3
  final String? endDate; // M1_DT4
  final String? productImage; // M1_IMG or product image URL

  const OrderHistoryEntity({
    this.lCode,
    this.groupCode,
    this.party,
    this.party1,
    this.rate,
    this.amount,
    this.quantity,
    this.discount,
    this.discountAmt,
    this.total,
    this.orderDate,
    this.customerName,
    this.customerContact,
    this.productName,
    this.productLst,
    this.productCst,
    this.productIt,
    this.productVal,
    this.startDate,
    this.endDate,
    this.productImage,
  });

  @override
  List<Object?> get props => [
    lCode,
    groupCode,
    party,
    party1,
    rate,
    amount,
    quantity,
    discount,
    discountAmt,
    total,
    orderDate,
    customerName,
    customerContact,
    productName,
    productLst,
    productCst,
    productIt,
    productVal,
    startDate,
    endDate,
    productImage,
  ];
}
