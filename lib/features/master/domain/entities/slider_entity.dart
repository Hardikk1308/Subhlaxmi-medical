import 'package:equatable/equatable.dart';

class SliderEntity extends Equatable {
  final String? m1Code;
  final String? m1Dc1;
  final String? m1Bt;

  SliderEntity({required this.m1Code, required this.m1Dc1, required this.m1Bt});

  @override
  List<Object?> get props => [];
}
