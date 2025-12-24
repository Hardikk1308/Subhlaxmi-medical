import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

// Events
abstract class CartEvent {}

class LoadCart extends CartEvent {}

class AddToCart extends CartEvent {
  final ProductEntity item;
  AddToCart({required this.item});
}

class RemoveFromCart extends CartEvent {
  final String productCode;
  RemoveFromCart({required this.productCode});
}

class UpdateQuantity extends CartEvent {
  final String productCode;
  final int quantity;
  UpdateQuantity({required this.productCode, required this.quantity});
}

class ClearCart extends CartEvent {}

class SyncCartFromHive extends CartEvent {}
