part of 'sub_category_bloc.dart';

sealed class SubCategoryEvent extends Equatable {
  const SubCategoryEvent();
  @override
  List<Object?> get props => [];
}

class FetchSubCategoryEvent extends SubCategoryEvent {
  final String catId;

  const FetchSubCategoryEvent({ required this.catId});

  @override
  List<Object?> get props => [catId];
}
