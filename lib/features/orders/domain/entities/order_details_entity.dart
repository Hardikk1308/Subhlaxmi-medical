import 'package:equatable/equatable.dart';

class OrderDetailsEntity extends Equatable {
  final String? productCode; // F4_LCODE
  final String? orderId; // F4_NO
  final String? userId; // F4_PARTY1
  final String? grandTotal; // F4_GTOT
  final String? amt1; // F4_AMT1
  final String? amt2; // F4_AMT2
  final String? bt; // F4_BT
  final String? paymentMethod; // F4_PM
  final String? ps; // F4_PS
  final String? orderDate; // F4_USERDT
  final String? customerName; // M2_CHK1
  final String? customerContact; // M2_CHK2
  final String? Address; // M2_CHK7

  const OrderDetailsEntity({
    this.productCode,
    this.orderId,
    this.userId,
    this.grandTotal,
    this.amt1,
    this.amt2,
    this.bt,
    this.paymentMethod,
    this.ps,
    this.orderDate,
    this.customerName,
    this.customerContact, this.Address,
  });

  @override
  List<Object?> get props => [
    productCode,
    orderId,
    userId,
    grandTotal,
    amt1,
    amt2,
    bt,
    paymentMethod,
    ps,
    orderDate,
    customerName,
    customerContact,
    Address,
  ];
}
