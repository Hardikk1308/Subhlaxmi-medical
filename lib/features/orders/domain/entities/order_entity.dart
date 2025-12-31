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

  factory OrderEntity.fromJson(Map<String, dynamic> json) {
    return OrderEntity(
      f4Lcode: json['f4Lcode']?.toString(),
      f4No: json['f4No']?.toString(),
      f4Party1: json['f4Party1']?.toString(),
      f4Gtot: json['f4Gtot']?.toString(),
      f4Amt1: json['f4Amt1']?.toString(),
      f4Amt2: json['f4Amt2']?.toString(),
      f4Bt: json['f4Bt']?.toString(),
      f4Pm: json['f4Pm']?.toString(),
      f4Ps: json['f4Ps']?.toString(),
      f4Userdt: json['f4Userdt']?.toString(),
      m2Chk1: json['m2Chk1']?.toString(),
      m2Chk2: json['m2Chk2']?.toString(),
      m2Chk7: json['m2Chk7']?.toString(),
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
