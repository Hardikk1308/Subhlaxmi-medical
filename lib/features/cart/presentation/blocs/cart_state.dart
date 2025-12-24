// cart_state.dart
import 'package:equatable/equatable.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

class CartState extends Equatable {
  final Map<String, ProductEntity> itemsMap; // productCode -> ProductEntity
  final Map<String, int> quantities; // productCode -> quantity

  const CartState({this.itemsMap = const {}, this.quantities = const {}});

  // Computed property: Get items as a list
  List<ProductEntity> get items => itemsMap.values.toList();

  CartState copyWith({
    Map<String, ProductEntity>? itemsMap,
    Map<String, int>? quantities,
  }) {
    return CartState(
      itemsMap: itemsMap ?? this.itemsMap,
      quantities: quantities ?? this.quantities,
    );
  }

  int get totalItems => quantities.values.fold(0, (sum, qty) => sum + qty);

  double get subtotal {
    double sum = 0;
    itemsMap.forEach((code, item) {
      final price = double.tryParse(item.M1_AMT2 ?? "0") ?? 0;
      final qty = quantities[code] ?? 0;
      sum += price * qty;
    });
    return sum;
  }

  @override
  List<Object?> get props => [itemsMap, quantities];
}
