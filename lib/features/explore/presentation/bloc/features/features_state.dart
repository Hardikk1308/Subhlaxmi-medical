part of 'features_bloc.dart';

sealed class FeaturesState extends Equatable {
  const FeaturesState();

  @override
  List<Object> get props => [];
}

final class FeaturesInitial extends FeaturesState {}

final class FeaturesLoading extends FeaturesState {}

final class FeaturesLoaded extends FeaturesState {
  final List<FeaturesEntity> featuresEntity;
  FeaturesLoaded({required this.featuresEntity});
}

final class FeaturesError extends FeaturesState {
  final String message;
  FeaturesError({required this.message});
}
