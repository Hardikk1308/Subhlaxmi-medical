part of 'features_bloc.dart';

sealed class FeaturesEvent extends Equatable {
  const FeaturesEvent();

  @override
  List<Object> get props => [];
}

class FetchFeaturesEvent extends FeaturesEvent {}
