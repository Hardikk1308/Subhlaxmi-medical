part of 'banner_bloc.dart';

sealed class BannerState extends Equatable {
  const BannerState();

  @override
  List<Object> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerSuccess extends BannerState {
  final List<SliderEntity> banners;

  const BannerSuccess({required this.banners});

  @override
  List<Object> get props => [banners];
}

class BannerError extends BannerState {
  final int statusCode;
  final String message;

  const BannerError({required this.statusCode, required this.message});

  @override
  List<Object> get props => [statusCode, message];
}
