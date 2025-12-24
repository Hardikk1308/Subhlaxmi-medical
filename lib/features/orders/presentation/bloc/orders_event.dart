import 'package:equatable/equatable.dart';

abstract class OrdersEvent extends Equatable {
  const OrdersEvent();

  @override
  List<Object?> get props => [];
}

class FetchOrderListEvent extends OrdersEvent {
  final String userId;

  const FetchOrderListEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class FetchOrderDetailsEvent extends OrdersEvent {
  final String orderId;

  const FetchOrderDetailsEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class FetchOrderHistoryEvent extends OrdersEvent {
  final String orderId;

  const FetchOrderHistoryEvent({required this.orderId});

  @override
  List<Object?> get props => [orderId];
}

class UpdateOrderStatusEvent extends OrdersEvent {
  final String orderId;
  final String status;

  const UpdateOrderStatusEvent({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class InsertOrderEvent extends OrdersEvent {
  final Map<String, dynamic> orderData;

  const InsertOrderEvent({required this.orderData});

  @override
  List<Object?> get props => [orderData];
}
