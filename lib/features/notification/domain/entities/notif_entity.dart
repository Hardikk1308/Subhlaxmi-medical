import 'package:equatable/equatable.dart';

class NotifEntity extends Equatable {
  final String? f4Lcode;
  final String? f4Party1;
  final String? f4Txt1;
  final String? f4Des1;
  final String? f4Bt;
  final String? f4Userdt;

  const NotifEntity({
    required this.f4Lcode,
    required this.f4Party1,
    required this.f4Txt1,
    required this.f4Des1,
    required this.f4Bt,
    required this.f4Userdt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
