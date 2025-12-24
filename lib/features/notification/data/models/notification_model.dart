import 'package:mediecom/features/notification/domain/entities/notif_entity.dart';

class NotificationModel extends NotifEntity {
  const NotificationModel({
    super.f4Lcode,
    super.f4Party1,
    super.f4Txt1,
    super.f4Des1,
    super.f4Bt,
    super.f4Userdt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      f4Lcode: json['F4_LCODE']?.toString(),
      f4Party1: json['F4_PARTY1']?.toString(),
      f4Txt1: json['F4_TXT1'],
      f4Des1: json['F4_DES1'],
      f4Bt: json['F4_BT'],
      f4Userdt: json['F4_USERDT'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'F4_LCODE': f4Lcode,
      'F4_PARTY1': f4Party1,
      'F4_TXT1': f4Txt1,
      'F4_DES1': f4Des1,
      'F4_BT': f4Bt,
      'F4_USERDT': f4Userdt,
    };
  }
}
