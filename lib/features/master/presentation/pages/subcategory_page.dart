import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/services/routes/arguments/product_details.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_event.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_state.dart';
import 'package:mediecom/features/cart/presentation/pages/cart.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/presentation/bloc/product_bloc.dart';
import 'package:mediecom/features/explore/presentation/pages/product_details.dart';
import 'package:mediecom/features/explore/presentation/widgets/floating_button.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/master/presentation/blocs/category/category_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/sub_category/sub_category_bloc.dart';

class SubcategoryPage extends StatefulWidget {
  static const path = '/sub_category';
  const SubcategoryPage({super.key});

  @override
  State<SubcategoryPage> createState() => _SubcategoryPageState();
}

class _SubcategoryPageState extends State<SubcategoryPage> {
  int selectedIndex = 0;
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    // Fetch products for the first category on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchProductsForCategory();
    });
  }

  void _fetchProductsForCategory() {
    final categoryState = context.read<CategoryBloc>().state;
    if (categoryState is CategorySuccess && categoryState.categories.isNotEmpty) {
      final selectedCategory = categoryState.categories[selectedIndex];
      selectedCategoryId = selectedCategory.m1Code;
      context.read<ProductBloc>().add(
        FetchProducts(categoryId: selectedCategoryId),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: GradientAppBar(
        name: "Categories",
        address: "",
        isUserName: false,
        leading: true,
      ),

      floatingActionButton: Container(
        height: 70,
        child: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            final items = state.items;

            if (items.isEmpty) {
              return SizedBox.shrink();
            }
            return FloatingCartButton(
              itemCount: items.length,

              onTap: () {
                context.go(Cart.path);
              },
            );
          },
        ),
      ),

      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side category navigation
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategorySuccess) {
                final subcategory = state.categories;
                return Container(
                  width: 100,
                  color: Colors.white,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: subcategory.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedIndex == index;
                      return GestureDetector(
                        onTap: () {
                          setState(() => selectedIndex = index);
                          // Fetch products for the selected category
                          selectedCategoryId = subcategory[index].m1Code;
                          context.read<ProductBloc>().add(
                            FetchProducts(categoryId: selectedCategoryId),
                          );
                        },
                        child: _buildCategoryItem(
                          subcategory[index].m1Name ?? "",
                          subcategory[index].m1dc1,
                          isSelected,
                        ),
                      );
                    },
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),

          Container(width: 1, color: Colors.grey[200]),

          // Right side product list
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // _sortFilterButton(Iconsax.sort, "Sort"),
                      const SizedBox(width: 8),
                      // _sortFilterButton(Iconsax.filter, "Filters"),
                    ],
                  ),
                ),

                // Products list with synced quantities
                Expanded(
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, productState) {
                      if (productState is ProductLoaded) {
                        final products = productState.products;

                        if (products.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Iconsax.box,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No products found',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return BlocBuilder<CartBloc, CartState>(
                          builder: (context, cartState) {
                            return ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: products.length,
                              itemBuilder: (context, index) {
                                final data = products[index];
                                final quantity =
                                    cartState.quantities[data.M1_CODE] ?? 0;

                                return InkWell(
                                  onTap: () {
                                    context.push(
                                      ProductDetailPage.path,
                                      extra: ProductDetailsArgs(
                                        tag: "product_card_${data.M1_CODE}_$index",
                                        cate: data,
                                      ),
                                    );
                                  },
                                  child: _buildProductCard(
                                    context: context,
                                    data: data,
                                    quantity: quantity,
                                  ),
                                );
                              },
                            );
                          },
                        );
                      }

                      if (productState is ProductLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colours.primaryColor,
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(String name, String imageUrl, bool selected) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: selected
            ? Colours.primaryColor.withOpacity(0.08)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        border: selected
            ? Border.all(color: Colours.primaryColor, width: 2)
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: selected ? Colours.primaryColor : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              boxShadow: selected
                  ? [
                      BoxShadow(
                        color: Colours.primaryColor.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: Image.network(
              "${ApiConstants.categoryBase}$imageUrl",
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Iconsax.category5,
                  color: selected ? Colors.white : Colors.grey[600],
                  size: 24,
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Text(
            name,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: selected ? Colours.primaryColor : Colors.grey[700],
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _sortFilterButton(IconData icon, String text) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: Colors.grey[700]),
            const SizedBox(width: 6),
            Text(
              text,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard({
    required BuildContext context,
    required ProductEntity data,
    required int quantity,
  }) {
    double originalPrice = double.tryParse(data.M1_AMT1 ?? '0') ?? 0;
    double discountedPrice = double.tryParse(data.M1_AMT2 ?? '0') ?? 0;
    int discountPercent = 0;

    if (originalPrice > 0 && discountedPrice > 0) {
      discountPercent =
          (((originalPrice - discountedPrice) / originalPrice) * 100).round();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[100],
                ),
                clipBehavior: Clip.antiAlias,
                child: data.image.isNotEmpty
                    ? Image.network(
                        resolveUrl(data.image[0]),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Iconsax.box,
                            size: 40,
                            color: Colors.grey[400],
                          );
                        },
                      )
                    : Icon(Iconsax.box, size: 40, color: Colors.grey[400]),
              ),
              const SizedBox(height: 6),
              if (discountPercent > 0)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    "$discountPercent% OFF",
                    style: const TextStyle(
                      color: Color(0xFFEF4444),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  data.M1_NAME ?? "Medicine name",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: Color(0xFF1A1A1A),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                if (data.M1_CST != null && data.M1_CST!.isNotEmpty)
                  Text(
                    data.M1_CST!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      "₹${data.M1_AMT2 ?? '0'}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF10B981),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (originalPrice > discountedPrice)
                      Text(
                        "₹${data.M1_AMT1}",
                        style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey[500],
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildCartControl(context, data, quantity),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartControl(
    BuildContext context,
    ProductEntity data,
    int quantity,
  ) {
    if (quantity == 0) {
      return GestureDetector(
        onTap: () => context.read<CartBloc>().add(AddToCart(item: data)),
        child: Container(
          height: 36,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colours.primaryColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colours.primaryColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Iconsax.add, color: Colors.white, size: 16),
              SizedBox(width: 6),
              Text(
                "ADD",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: Colours.primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            onTap: () {
              context.read<CartBloc>().add(
                UpdateQuantity(
                  productCode: data.M1_CODE ?? '',
                  quantity: quantity - 1,
                ),
              );
            },
            child: const SizedBox(
              width: 32,
              height: 36,
              child: Center(
                child: Icon(Iconsax.minus, color: Colors.white, size: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "$quantity",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          InkWell(
            onTap: () {
              context.read<CartBloc>().add(
                UpdateQuantity(
                  productCode: data.M1_CODE ?? '',
                  quantity: quantity + 1,
                ),
              );
            },
            child: const SizedBox(
              width: 32,
              height: 36,
              child: Center(
                child: Icon(Iconsax.add, color: Colors.white, size: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
