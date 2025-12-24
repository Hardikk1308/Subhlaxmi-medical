import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/domain/usecases/search_usecase.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUsecase searchUsecase;

  SearchBloc(this.searchUsecase) : super(SearchInitial()) {
    on<SearchEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<PerformSearchEvent>(performSearch);
  }

  Future<void> performSearch(
    PerformSearchEvent event,
    Emitter<SearchState> emit,
  ) async {
    emit(SearchLoading());
    final result = await searchUsecase.call(event.query);
    result.fold(
      (failure) => emit(SearchError(message: '${failure.message}')),
      (products) => emit(SearchLoaded(products: products)),
    );
  }
}
