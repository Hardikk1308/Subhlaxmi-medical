import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mediecom/core/common/usecases/usecase.dart';
import 'package:mediecom/features/master/domain/use_cases/get_subcategory_usecase.dart';

import '../../../../../core/utils/utils.dart';
import '../../../domain/entities/sub_category_entity.dart';

part 'sub_category_event.dart';
part 'sub_category_state.dart';

class SubCategoryBloc extends Bloc<SubCategoryEvent, SubCategoryState> {
  final GetSubcategoryUsecase getSubCategoryUseCase;

  SubCategoryBloc({required this.getSubCategoryUseCase})
    : super(SubCategoryInitial()) {
    on<SubCategoryEvent>((event, emit) {
      // TODO: implement event handler
    });

    on<FetchSubCategoryEvent>((event, emit) async {
      emit(SubCategoryLoading());
      final result = await getSubCategoryUseCase(NoParams());

      result.fold(
        (failure) => emit(
          SubCategoryError(
            message: mapFailureToMessage(failure),
            statusCode: failure.statusCode,
          ),
        ),
        (subCategories) =>
            emit(SubCategorySuccess(subCategories: subCategories)),
      );
    });
  }
}
