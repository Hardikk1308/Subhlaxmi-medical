import 'package:equatable/equatable.dart';

class SubcategoryEntity extends Equatable {
  final String? m1Code;
  final String? m1Name;
  final String? m1Dc1;
  final String? m1Bt;
  final String? m1Group;
  final String? categoryName;

  const SubcategoryEntity({
    this.m1Code,
    this.m1Name,
    this.m1Dc1,
    this.m1Bt,
    this.m1Group,
    this.categoryName,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    m1Code,
    m1Name,
    m1Dc1,
    m1Bt,
    m1Group,
    categoryName,
  ];
}
