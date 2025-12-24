import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/orders/domain/entities/order_entity.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';

class FetchOrderListUseCase implements UseCase<List<OrderEntity>, String> {
  final OrdersRepository repository;

  FetchOrderListUseCase(this.repository);

  @override
  Future<Either<Failure, List<OrderEntity>>> call(String userId) async {
    return await repository.fetchOrderList(userId);
  }
}
