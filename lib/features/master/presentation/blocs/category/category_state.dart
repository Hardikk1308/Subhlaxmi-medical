part of 'category_bloc.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();
  @override
  List<Object> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategorySuccess extends CategoryState {
  final List<CategoryEntity> categories;

  const CategorySuccess({required this.categories});

  @override
  List<Object> get props => [categories];
}

class CategoryError extends CategoryState {
  final int statusCode;
  final String message;

  const CategoryError({required this.statusCode, required this.message});

  @override
  List<Object> get props => [statusCode, message];
}
