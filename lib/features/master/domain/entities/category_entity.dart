import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String m1Code;
  final String m1Name;
  final String m1Bt;
  final String m1dc1;

  CategoryEntity({
    required this.m1Code,
    required this.m1Name,
    required this.m1Bt,
    required this.m1dc1,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
