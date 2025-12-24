import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/master/domain/use_cases/get_category_use_case.dart';

import '../../../../../core/common/usecases/usecase.dart';
import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/category_entity.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final GetCategoryUseCase getCategoryUseCase;

  CategoryBloc({required this.getCategoryUseCase}) : super(CategoryInitial()) {
    on<CategoryEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchCategoryEvent>((event, emit) async {
      emit(CategoryLoading());
      final result = await getCategoryUseCase(NoParams());

      result.fold(
        (failure) => emit(
          CategoryError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (categories) => emit(CategorySuccess(categories: categories)),
      );
    });
  }
}
