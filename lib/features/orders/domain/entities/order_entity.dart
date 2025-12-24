import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String? f4Lcode;
  final String? f4No;
  final String? f4Party1;
  final String? f4Gtot;
  final String? f4Amt1;
  final String? f4Amt2;
  final String? f4Bt;
  final String? f4Pm;
  final String? f4Ps;
  final String? f4Userdt;
  final String? m2Chk1;
  final String? m2Chk2;
  final String? m2Chk7;

  OrderEntity({
    this.f4Lcode,
    this.f4No,
    this.f4Party1,
    this.f4Gtot,
    this.f4Amt1,
    this.f4Amt2,
    this.f4Bt,
    this.f4Pm,
    this.f4Ps,
    this.f4Userdt,
    this.m2Chk1,
    this.m2Chk2,
    this.m2Chk7,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
