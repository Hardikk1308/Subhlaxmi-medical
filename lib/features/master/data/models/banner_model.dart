import 'package:mediecom/features/master/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    super.id,
    super.title,
    super.image,
    super.url,
    super.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      url: json['url'],
      isActive: json['is_active'] == '1',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'url': url,
      'is_active': isActive,
    };
  }
}
