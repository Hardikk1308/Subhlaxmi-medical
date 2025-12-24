import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/orders/domain/repositories/orders_repository.dart';

class UpdateOrderStatusParams extends Equatable {
  final String orderId;
  final String status;

  const UpdateOrderStatusParams({required this.orderId, required this.status});

  @override
  List<Object?> get props => [orderId, status];
}

class UpdateOrderStatusUseCase
    implements UseCase<void, UpdateOrderStatusParams> {
  final OrdersRepository repository;

  UpdateOrderStatusUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(UpdateOrderStatusParams params) async {
    return await repository.updateOrderStatus(params.orderId, params.status);
  }
}
