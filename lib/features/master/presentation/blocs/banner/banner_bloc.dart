import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/master/domain/entities/slider_entity.dart';
import 'package:mediecom/features/master/domain/use_cases/get_banners_usecase.dart';

import '../../../../../core/utils/utils.dart';

part 'banner_event.dart';
part 'banner_state.dart';

class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final GetBannerUseCase getBannerUseCase;

  BannerBloc({required this.getBannerUseCase}) : super(BannerInitial()) {
    on<BannerEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchBannerEvent>((event, emit) async {
      emit(BannerLoading());
      final result = await getBannerUseCase(NoParams());

      result.fold(
        (failure) => emit(
          BannerError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (banners) => emit(BannerSuccess(banners: banners)),
      );
    });
  }
}
