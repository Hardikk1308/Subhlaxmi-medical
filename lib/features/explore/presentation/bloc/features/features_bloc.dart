import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/explore/domain/entities/featured_entity..dart';
import 'package:mediecom/features/explore/domain/usecases/fetch_features_usecase.dart';

part 'features_event.dart';
part 'features_state.dart';

class FeaturesBloc extends Bloc<FeaturesEvent, FeaturesState> {
  final FetchFeaturesUsecase fetchFeaturesUsecase;

  FeaturesBloc(this.fetchFeaturesUsecase) : super(FeaturesInitial()) {
    on<FeaturesEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchFeaturesEvent>(_onFetchFeatures);
  }

  Future<void> _onFetchFeatures(
    FetchFeaturesEvent event,
    Emitter<FeaturesState> emit,
  ) async {
    emit(FeaturesLoading());
    final result = await fetchFeaturesUsecase.call(NoParams());
    result.fold(
      (failure) => emit(FeaturesError(message: '${failure.message}')),
      (products) => emit(FeaturesLoaded(featuresEntity: products)),
    );
  }
}
