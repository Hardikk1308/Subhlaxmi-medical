import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/features/orders/domain/entities/order_details_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_entity.dart';
import 'package:mediecom/features/orders/domain/entities/order_history_entity.dart';

abstract class OrdersRepository {
  Future<Either<Failure, List<OrderEntity>>> fetchOrderList(String userId);
  Future<Either<Failure, OrderDetailsEntity>> fetchOrderDetails(String orderId);
  Future<Either<Failure, List<OrderHistoryEntity>>> fetchOrderHistory(
    String orderId,
  );
  Future<Either<Failure, void>> updateOrderStatus(
    String orderId,
    String status,
  );
  Future<Either<Failure, String>> insertOrder(Map<String, dynamic> orderData);
}
