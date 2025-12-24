import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/orders/domain/use_cases/fetch_order_details_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/fetch_order_history_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/fetch_order_list_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/insert_order_usecase.dart';
import 'package:mediecom/features/orders/domain/use_cases/update_order_status_usecase.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_event.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_state.dart';

class OrdersBloc extends Bloc<OrdersEvent, OrdersState> {
  final FetchOrderListUseCase fetchOrderList;
  final FetchOrderDetailsUseCase fetchOrderDetails;
  final FetchOrderHistoryUseCase fetchOrderHistory;
  final UpdateOrderStatusUseCase updateOrderStatus;
  final InsertOrderUseCase insertOrder;

  OrdersBloc({
    required this.fetchOrderList,
    required this.fetchOrderDetails,
    required this.fetchOrderHistory,
    required this.updateOrderStatus,
    required this.insertOrder,
  }) : super(OrdersInitial()) {
    on<FetchOrderListEvent>(_onFetchOrderList);
    on<FetchOrderDetailsEvent>(_onFetchOrderDetails);
    on<FetchOrderHistoryEvent>(_onFetchOrderHistory);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
    on<InsertOrderEvent>(_onInsertOrder);
  }

  Future<void> _onFetchOrderList(
    FetchOrderListEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    final result = await fetchOrderList(event.userId);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (orders) => emit(OrderListSuccess(orders)),
    );
  }

  Future<void> _onFetchOrderDetails(
    FetchOrderDetailsEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    final result = await fetchOrderDetails(event.orderId);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (orderDetails) => emit(OrderDetailsSuccess(orderDetails)),
    );
  }

  Future<void> _onFetchOrderHistory(
    FetchOrderHistoryEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    final result = await fetchOrderHistory(event.orderId);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (orderHistory) => emit(OrderHistorySuccess(orderHistory)),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatusEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    final result = await updateOrderStatus(
      UpdateOrderStatusParams(orderId: event.orderId, status: event.status),
    );
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (_) => emit(OrderStatusUpdateSuccess()),
    );
  }

  Future<void> _onInsertOrder(
    InsertOrderEvent event,
    Emitter<OrdersState> emit,
  ) async {
    emit(OrdersLoading());
    final result = await insertOrder(event.orderData);
    result.fold(
      (failure) => emit(OrdersFailure(failure.message)),
      (orderId) => emit(OrderInsertSuccess(orderId)),
    );
  }
}
