import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/account_review/data/models/company_model.dart';
import 'package:mediecom/features/account_review/domain/usecases/check_account_status_usecase.dart';

part 'account_review_event.dart';
part 'account_review_state.dart';

class AccountReviewBloc extends Bloc<AccountReviewEvent, AccountReviewState> {
  final CheckAccountStatusUseCase checkAccountStatusUseCase;
  Timer? _pollingTimer;
  int _checkCount = 0;

  AccountReviewBloc({required this.checkAccountStatusUseCase})
      : super(const AccountReviewInitial()) {
    on<CheckAccountStatusEvent>(_onCheckAccountStatus);
    on<StartPollingEvent>(_onStartPolling);
    on<StopPollingEvent>(_onStopPolling);
  }

  Future<void> _onCheckAccountStatus(
    CheckAccountStatusEvent event,
    Emitter<AccountReviewState> emit,
  ) async {
    emit(const AccountReviewLoading());

    final result = await checkAccountStatusUseCase(
      CheckAccountStatusParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(
        AccountReviewError(message: mapFailureToMessage(failure)),
      ),
      (company) => _handleCompanyStatus(company, emit),
    );
  }

  Future<void> _onStartPolling(
    StartPollingEvent event,
    Emitter<AccountReviewState> emit,
  ) async {
    // Initial check
    final result = await checkAccountStatusUseCase(
      CheckAccountStatusParams(userId: event.userId),
    );

    result.fold(
      (failure) => emit(
        AccountReviewError(message: mapFailureToMessage(failure)),
      ),
      (company) {
        _checkCount = 0;
        _handleCompanyStatus(company, emit);

        // Start polling if still under review
        if (_isUnderReview(company)) {
          _pollingTimer?.cancel();
          _pollingTimer = Timer.periodic(event.interval, (_) async {
            _checkCount++;
            final pollResult = await checkAccountStatusUseCase(
              CheckAccountStatusParams(userId: event.userId),
            );

            pollResult.fold(
              (failure) => emit(
                AccountReviewError(message: mapFailureToMessage(failure)),
              ),
              (updatedCompany) {
                _handleCompanyStatus(updatedCompany, emit);
                if (!_isUnderReview(updatedCompany)) {
                  _pollingTimer?.cancel();
                }
              },
            );
          });
        }
      },
    );
  }

  Future<void> _onStopPolling(
    StopPollingEvent event,
    Emitter<AccountReviewState> emit,
  ) async {
    _pollingTimer?.cancel();
    _checkCount = 0;
  }

  void _handleCompanyStatus(
    CompanyModel company,
    Emitter<AccountReviewState> emit,
  ) {
    final status = company.coDes1?.toLowerCase() ?? '';
    final m2Bt = company.m2Bt?.toLowerCase() ?? '';

    // Check if M2_BT is active
    if (m2Bt != 'active') {
      // Account is not active yet, stay in review
      emit(AccountReviewPolling(company: company, checkCount: _checkCount));
      return;
    }

    if (status.contains('approved') || status.contains('active')) {
      emit(AccountReviewApproved(company: company));
    } else if (status.contains('rejected') || status.contains('declined')) {
      emit(AccountReviewRejected(
        company: company,
        reason: company.coDes1 ?? 'Your account has been rejected.',
      ));
    } else if (status.contains('under review') || status.contains('under reivew')) {
      emit(AccountReviewPolling(company: company, checkCount: _checkCount));
    } else {
      emit(AccountReviewUnderReview(company: company));
    }
  }

  bool _isUnderReview(CompanyModel company) {
    final status = company.coDes1?.toLowerCase() ?? '';
    final m2Bt = company.m2Bt?.toLowerCase() ?? '';
    
    // If M2_BT is not active, still under review
    if (m2Bt != 'active') {
      return true;
    }
    
    return status.contains('under review') || status.contains('under reivew');
  }

  @override
  Future<void> close() {
    _pollingTimer?.cancel();
    return super.close();
  }
}
