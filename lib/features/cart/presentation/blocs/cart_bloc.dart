import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mediecom/features/cart/data/data_sources/cart_service.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_event.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_state.dart';
import 'package:mediecom/features/explore/data/models/product_model.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(const CartState()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<ClearCart>(_onClearCart);
    on<SyncCartFromHive>(_onSyncCartFromHive);

    // Initial load from Hive
    add(SyncCartFromHive());
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    add(SyncCartFromHive());
  }

  Future<void> _onSyncCartFromHive(
    SyncCartFromHive event,
    Emitter<CartState> emit,
  ) async {
    final quantities = CartService.getAllQuantities();
    final backupProducts = CartBackupService.getAllProducts();

    final updatedItemsMap = <String, ProductEntity>{};

    for (var entry in quantities.entries) {
      final code = entry.key;
      final product = backupProducts[code];
      if (product != null) updatedItemsMap[code] = product;
    }

    emit(state.copyWith(itemsMap: updatedItemsMap, quantities: quantities));
  }

  // Future<void> _onSyncCartFromHive(
  //   SyncCartFromHive event,
  //   Emitter<CartState> emit,
  // ) async {
  //   final quantities = CartService.getAllQuantities();

  //   // Keep only items that exist in quantities
  //   final updatedItemsMap = Map<String, ProductEntity>.from(state.itemsMap);
  //   updatedItemsMap.removeWhere((code, item) => !quantities.containsKey(code));

  //   emit(state.copyWith(itemsMap: updatedItemsMap, quantities: quantities));

  //   print('🔄 Synced from Hive: ${quantities.length} items');
  // }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    final productCode = event.item.M1_CODE ?? '';

    print('🛒 AddToCart called');
    print('   Product Code: $productCode');
    print('   Product Name: ${event.item.M1_NAME}');

    if (productCode.isEmpty) {
      print('❌ Product code is empty, cannot add to cart');
      return;
    }

    // Update Hive
    await CartService.addItem(productCode);

    await CartBackupService.saveProduct(event.item as ProductModel);

    final newQuantity = CartService.getQuantity(productCode);

    print('   New quantity: $newQuantity');

    // Update state
    final updatedItemsMap = Map<String, ProductEntity>.from(state.itemsMap);
    final updatedQuantities = Map<String, int>.from(state.quantities);

    // Add or update item in map
    updatedItemsMap[productCode] = event.item;
    updatedQuantities[productCode] = newQuantity;

    emit(
      state.copyWith(itemsMap: updatedItemsMap, quantities: updatedQuantities),
    );

    print('✅ Item added to cart. Total items: ${updatedItemsMap.length}');
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    print('🗑️ RemoveFromCart: ${event.productCode}');

    // Update Hive
    await CartService.removeItem(event.productCode);

    // Update state
    final updatedItemsMap = Map<String, ProductEntity>.from(state.itemsMap);
    final updatedQuantities = Map<String, int>.from(state.quantities);

    updatedItemsMap.remove(event.productCode);
    updatedQuantities.remove(event.productCode);

    emit(
      state.copyWith(itemsMap: updatedItemsMap, quantities: updatedQuantities),
    );

    print('✅ Item removed. Remaining: ${updatedItemsMap.length}');
  }

  Future<void> _onUpdateQuantity(
    UpdateQuantity event,
    Emitter<CartState> emit,
  ) async {
    print('🔢 UpdateQuantity: ${event.productCode} -> ${event.quantity}');

    // Update Hive
    await CartService.updateQuantity(event.productCode, event.quantity);

    // Update state
    final updatedItemsMap = Map<String, ProductEntity>.from(state.itemsMap);
    final updatedQuantities = Map<String, int>.from(state.quantities);

    if (event.quantity <= 0) {
      // Remove item completely
      updatedItemsMap.remove(event.productCode);
      updatedQuantities.remove(event.productCode);
      print('   Quantity <= 0, removing item');
    } else {
      // Update quantity
      updatedQuantities[event.productCode] = event.quantity;
      print('   Updated quantity to ${event.quantity}');
    }

    emit(
      state.copyWith(itemsMap: updatedItemsMap, quantities: updatedQuantities),
    );

    print('✅ Quantity updated. Total items: ${updatedItemsMap.length}');
  }

  Future<void> _onClearCart(ClearCart event, Emitter<CartState> emit) async {
    print('🧹 Clearing cart');
    await CartService.clearCart();
    emit(const CartState());
    print('✅ Cart cleared');
  }
}
