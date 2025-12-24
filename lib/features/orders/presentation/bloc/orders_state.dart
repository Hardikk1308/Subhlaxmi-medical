import 'package:equatable/equatable.dart';
import 'package:mediecom/features/orders/domain/entities/order_details_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_history_entity.dart';

abstract class OrdersState extends Equatable {
  const OrdersState();

  @override
  List<Object?> get props => [];
}

class OrdersInitial extends OrdersState {}

class OrdersLoading extends OrdersState {}

class OrderListSuccess extends OrdersState {
  final List<OrderEntity> orders;

  const OrderListSuccess(this.orders);

  @override
  List<Object?> get props => [orders];
}

class OrderDetailsSuccess extends OrdersState {
  final OrderDetailsEntity orderDetails;

  const OrderDetailsSuccess(this.orderDetails);

  @override
  List<Object?> get props => [orderDetails];
}

class OrderHistorySuccess extends OrdersState {
  final List<OrderHistoryEntity> orderHistory;

  const OrderHistorySuccess(this.orderHistory);

  @override
  List<Object?> get props => [orderHistory];
}

class OrderStatusUpdateSuccess extends OrdersState {}

class OrderInsertSuccess extends OrdersState {
  final String orderId;

  const OrderInsertSuccess(this.orderId);

  @override
  List<Object?> get props => [orderId];
}

class OrdersFailure extends OrdersState {
  final String message;

  const OrdersFailure(this.message);

  @override
  List<Object?> get props => [message];
}
