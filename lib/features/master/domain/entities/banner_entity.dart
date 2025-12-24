import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final String? id;
  final String? title;
  final String? image;
  final String? url;
  final bool? isActive;

  const BannerEntity({
    this.id,
    this.title,
    this.image,
    this.url,
    this.isActive,
  });

  @override
  List<Object?> get props => [id, title, image, url, isActive];
}
