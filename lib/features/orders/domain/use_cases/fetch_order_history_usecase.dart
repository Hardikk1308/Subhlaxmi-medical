import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/orders/domain/entities/order_history_entity.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';

class FetchOrderHistoryUseCase
    implements UseCase<List<OrderHistoryEntity>, String> {
  final OrdersRepository repository;

  FetchOrderHistoryUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderHistoryEntity>>> call(String orderId) async {
    return await repository.fetchOrderHistory(orderId);
  }
}
