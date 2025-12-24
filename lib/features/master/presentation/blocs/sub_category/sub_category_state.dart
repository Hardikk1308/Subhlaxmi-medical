part of 'sub_category_bloc.dart';

sealed class SubCategoryState extends Equatable {
  const SubCategoryState();
  @override
  List<Object> get props => [];
}

class SubCategoryInitial extends SubCategoryState {}

class SubCategoryLoading extends SubCategoryState {}

class SubCategorySuccess extends SubCategoryState {
  final List<SubcategoryEntity> subCategories;

  const SubCategorySuccess({required this.subCategories});

  @override
  List<Object> get props => [subCategories];
}

class SubCategoryError extends SubCategoryState {
  final int statusCode;
  final String message;

  const SubCategoryError({required this.statusCode, required this.message});

  @override
  List<Object> get props => [statusCode, message];
}
