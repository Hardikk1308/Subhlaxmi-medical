import 'package:dartz/dartz.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/account_review/data/models/company_model.dart';
import 'package:mediecom/features/account_review/domain/repositories/account_review_repository.dart';

class CheckAccountStatusUseCase
    implements UseCase<CompanyModel, CheckAccountStatusParams> {
  final AccountReviewRepository repository;

  CheckAccountStatusUseCase({required this.repository});

  @override
  Future<Either<Failure, CompanyModel>> call(
    CheckAccountStatusParams params,
  ) async {
    return await repository.checkAccountStatus(params.userId);
  }
}

class CheckAccountStatusParams {
  final String userId;

  CheckAccountStatusParams({required this.userId});
}
