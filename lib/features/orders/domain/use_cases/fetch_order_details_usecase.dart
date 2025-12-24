import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/orders/domain/entities/order_details_entity.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';

class FetchOrderDetailsUseCase implements UseCase<OrderDetailsEntity, String> {
  final OrdersRepository repository;

  FetchOrderDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, OrderDetailsEntity>> call(String orderId) async {
    return await repository.fetchOrderDetails(orderId);
  }
}
