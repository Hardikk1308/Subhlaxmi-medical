import 'package:hive_flutter/hive_flutter.dart';
import 'package:mediecom/features/explore/data/models/product_model.dart';

class CartService {
  static const String _boxName = 'cart_box';
  static Box? _box;

  // Initialize Hive (No code generation needed!)
  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(_boxName);
  }

  static Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('CartService not initialized. Call init() first.');
    }
    return _box!;
  }

  // Get quantity for a specific product
  static int getQuantity(String productCode) {
    try {
      final data = box.get(productCode);
      if (data is Map) {
        return (data['quantity'] as int?) ?? 0;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }

  // Add or update item
  static Future<void> addItem(String productCode, {int quantity = 1}) async {
    try {
      final existingData = box.get(productCode);
      int currentQty = 0;

      if (existingData is Map) {
        currentQty = (existingData['quantity'] as int?) ?? 0;
      }

      await box.put(productCode, {
        'productCode': productCode,
        'quantity': currentQty + quantity,
        'addedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error adding item: $e');
    }
  }

  // Update quantity directly
  static Future<void> updateQuantity(String productCode, int quantity) async {
    try {
      if (quantity <= 0) {
        await removeItem(productCode);
        return;
      }

      await box.put(productCode, {
        'productCode': productCode,
        'quantity': quantity,
        'addedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  // Remove item
  static Future<void> removeItem(String productCode) async {
    try {
      await box.delete(productCode);
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Clear all items
  static Future<void> clearCart() async {
    try {
      await box.clear();
    } catch (e) {
      print('Error clearing cart: $e');
    }
  }

  // Get all items with quantities
  static Map<String, int> getAllQuantities() {
    try {
      final Map<String, int> quantities = {};
      for (var key in box.keys) {
        final data = box.get(key);
        if (data is Map && key is String) {
          quantities[key] = (data['quantity'] as int?) ?? 0;
        }
      }
      return quantities;
    } catch (e) {
      print('Error getting all quantities: $e');
      return {};
    }
  }

  // Get total items count
  static int getTotalItemsCount() {
    try {
      return getAllQuantities().values.fold(0, (sum, qty) => sum + qty);
    } catch (e) {
      return 0;
    }
  }

  // Listen to changes
  static Stream<BoxEvent> watchCart() {
    return box.watch();
  }
}

class CartBackupService {
  static const String _boxName = 'cart_products_box';
  static Box? _box;

  // Initialize the backup box
  static Future<void> init() async {
    _box = await Hive.openBox(_boxName);
  }

  static Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('CartBackupService not initialized.');
    }
    return _box!;
  }

  // Save full product
  static Future<void> saveProduct(ProductModel product) async {
    final code = product.M1_CODE ?? '';
    if (code.isEmpty) return;

    await box.put(code, product.toJson());
  }

  // Retrieve a single product
  static ProductModel? getProduct(String code) {
    final data = box.get(code);
    if (data != null) {
      return ProductModel.fromJson(Map<String, dynamic>.from(data));
    }
    return null;
  }

  // Retrieve all products
  static Map<String, ProductModel> getAllProducts() {
    final Map<String, ProductModel> items = {};
    for (var key in box.keys) {
      final product = getProduct(key);
      if (product != null) items[key] = product;
    }
    return items;
  }
}
