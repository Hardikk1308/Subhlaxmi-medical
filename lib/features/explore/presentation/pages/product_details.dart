import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_event.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_state.dart';
import 'package:mediecom/features/cart/presentation/pages/cart.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/presentation/bloc/product_bloc.dart';
import 'package:mediecom/features/explore/presentation/widgets/floating_button.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';

class ProductDetailPage extends StatefulWidget {
  static const path = '/product-details';
  const ProductDetailPage({super.key, required this.tag, required this.data});

  final String tag;
  final ProductEntity data;

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage>
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  int _pageIndex = 0;
  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late ProductEntity _displayData;
  bool _isLoadingDetails = false;
  String _descriptionText = '';
  StreamSubscription<ProductState>? _subscription;

  @override
  void initState() {
    super.initState();
    _displayData = widget.data;
    _descriptionText = _getDescriptionFromData(widget.data);
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );
    _animController.forward();

    // Set up listener BEFORE fetching
    _setupBlocListener();

    // Then fetch details
    _fetchProductDetails();
  }

  String _getDescriptionFromData(ProductEntity data) {
    final add1Length = data.M1_ADD1?.length ?? 0;
    final add2Length = data.M1_ADD2?.length ?? 0;

    if (add1Length > 0) {
      appLog('_getDescriptionFromData - M1_ADD1 length: $add1Length');
      appLog(
        '_getDescriptionFromData - M1_ADD1: ${data.M1_ADD1?.substring(0, add1Length > 50 ? 50 : add1Length) ?? "null"}',
      );
    }
    if (add2Length > 0) {
      appLog('_getDescriptionFromData - M1_ADD2 length: $add2Length');
      appLog(
        '_getDescriptionFromData - M1_ADD2: ${data.M1_ADD2?.substring(0, add2Length > 50 ? 50 : add2Length) ?? "null"}',
      );
    }

    if (data.M1_ADD1 != null && data.M1_ADD1!.isNotEmpty) {
      return _cleanHtmlContent(data.M1_ADD1!);
    } else if (data.M1_ADD2 != null && data.M1_ADD2!.isNotEmpty) {
      return _cleanHtmlContent(data.M1_ADD2!);
    }
    return 'No description available.';
  }

  void _setupBlocListener() {
    final productBloc = context.read<ProductBloc>();

    _subscription = productBloc.stream.listen((state) {
      appLog('ProductDetailPage - Stream received: ${state.runtimeType}');

      if (state is ProductDetailsLoaded) {
        appLog(
          'ProductDetailPage - ProductDetailsLoaded for code: ${state.product.M1_CODE}',
        );
        appLog('ProductDetailPage - Widget data code: ${widget.data.M1_CODE}');
        appLog(
          'ProductDetailPage - M1_ADD1 length: ${state.product.M1_ADD1?.length ?? 0}',
        );
        final previewLength = (state.product.M1_ADD1?.length ?? 0) < 100
            ? (state.product.M1_ADD1?.length ?? 0)
            : 100;
        appLog(
          'ProductDetailPage - M1_ADD1 preview: ${state.product.M1_ADD1?.substring(0, previewLength) ?? "null"}',
        );

        if (state.product.M1_CODE == widget.data.M1_CODE) {
          if (mounted) {
            appLog('ProductDetailPage - Updating display data NOW');
            setState(() {
              _displayData = state.product;
              _descriptionText = _getDescriptionFromData(state.product);
              _isLoadingDetails = false;
              appLog(
                'ProductDetailPage - Description updated: $_descriptionText',
              );
            });
          }
        }
      } else if (state is ProductDetailsLoading) {
        if (mounted) {
          setState(() {
            _isLoadingDetails = true;
          });
        }
      } else if (state is ProductFailure) {
        appLog('ProductDetailPage - Failure: ${state.message}');
        if (mounted) {
          setState(() {
            _isLoadingDetails = false;
          });
        }
      }
    });
  }

  void _fetchProductDetails() {
    if (widget.data.M1_CODE == null || widget.data.M1_CODE!.isEmpty) {
      appLog('ProductDetailPage - M1_CODE is empty, skipping fetch');
      return;
    }

    appLog(
      'ProductDetailPage - Dispatching FetchProductDetails for: ${widget.data.M1_CODE}',
    );

    context.read<ProductBloc>().add(
      FetchProductDetails(productCode: widget.data.M1_CODE!),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Color get primaryGreen => const Color(0xFF25A96E);
  Color get paleGreen => const Color(0xFFE9F9EF);
  Color get palePeach => const Color(0xFFFFF3EA);
  Color get lightGreenBg => const Color(0xFFF5FDF9);

  @override
  Widget build(BuildContext context) {
    return _buildProductDetailsUI();
  }

  Widget _buildProductDetailsUI() {
    final data = _displayData;
    appLog('_buildProductDetailsUI - Rendering with M1_CODE: ${data.M1_CODE}');
    appLog('_buildProductDetailsUI - Description: $_descriptionText');

    final price = (data.M1_AMT2 ?? 00).toString();
    final oldPrice = (data.M1_AMT1 ?? 00).toString();
    final name = data.M1_NAME ?? 'Paracetamol';
    final Formula = (data.M1_CST?.isNotEmpty ?? false) ? data.M1_CST : null;
    final Expiry = (data.M1_DT4?.isNotEmpty ?? false) ? data.M1_DT4 : null;
    final Batch = (data.M1_LST?.isNotEmpty ?? false) ? data.M1_LST : null;
    final images = List<String>.from(data.image);

    // Calculate discount percentage
    final discount = data.M1_AMT1 != null && data.M1_AMT2 != null
        ? (((double.parse(data.M1_AMT1!) - double.parse(data.M1_AMT2!)) /
                      double.parse(data.M1_AMT1!)) *
                  100)
              .round()
        : 0;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: GradientAppBar(
        name: name,
        address: "address",
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image carousel with enhanced styling
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _buildImageCarousel(images),
                ),

                const SizedBox(height: 12),

                // Main content card
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(28),
                      topRight: Radius.circular(28),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tags row
                        Row(
                          children: [
                            _buildPrescriptionTag(),
                            const SizedBox(width: 8),
                            if (discount > 0) _buildDiscountBadge(discount),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Title & subtitle
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Iconsax.box,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                Formula ?? 'No formula available',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Icon(
                              Iconsax.ticket_expired,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),

                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                Expiry ?? 'Expirey date not available',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        Row(
                          children: [
                            Icon(
                              Iconsax.card_pos,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),

                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                Batch ?? 'No Batch available',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Price card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [paleGreen, lightGreenBg],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: primaryGreen.withOpacity(0.2),
                              width: 1.5,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Price',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹$price',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.w900,
                                            color: primaryGreen,
                                            height: 1,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          child: Text(
                                            '₹$oldPrice',
                                            style: TextStyle(
                                              fontSize: 16,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              decorationThickness: 2,
                                              color: Colors.grey.shade500,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: primaryGreen,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Iconsax.verify5,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'In Stock',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Category badge
                        _buildCategoryBadge(data.category_name ?? 'Medicine'),

                        const SizedBox(height: 24),

                        // Sections header
                        Text(
                          'Product Information',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Description section with loading state
                        _isLoadingDetails
                            ? _buildLoadingDescription()
                            : _buildDescriptionSection(_descriptionText),

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // Enhanced bottom bar with quantity controls
      bottomNavigationBar: BlocBuilder<CartBloc, CartState>(
        builder: (context, cartState) {
          final quantity = cartState.quantities[data.M1_CODE] ?? 0;

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: _buildBottomCartButton(context, quantity),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingDescription() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Iconsax.document_text,
                  color: primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Shimmer loading effect
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(3, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  height: 14,
                  width: index == 2 ? 200.0 : double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomCartButton(BuildContext context, int quantity) {
    if (quantity == 0) {
      // Add to Cart Button
      return ElevatedButton(
        onPressed: () {
          context.read<CartBloc>().add(AddToCart(item: widget.data));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  Icon(Iconsax.tick_circle5, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    '${widget.data.M1_NAME} added to cart',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor: primaryGreen,
              duration: const Duration(seconds: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: primaryGreen.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(vertical: 18),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.shopping_cart, size: 22),
            const SizedBox(width: 10),
            const Text(
              'Add to Cart',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      );
    } else {
      // Quantity Controls
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: primaryGreen,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: primaryGreen.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Decrease Button
            Expanded(
              child: InkWell(
                onTap: () {
                  context.read<CartBloc>().add(
                    UpdateQuantity(
                      productCode: widget.data.M1_CODE ?? '',
                      quantity: quantity - 1,
                    ),
                  );
                },
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(
                    Iconsax.minus,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              ),
            ),

            // Quantity Display
            Container(
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.2)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$quantity',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'in cart',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            // Increase Button
            Expanded(
              child: InkWell(
                onTap: () {
                  context.read<CartBloc>().add(
                    UpdateQuantity(
                      productCode: widget.data.M1_CODE ?? '',
                      quantity: quantity + 1,
                    ),
                  );
                },
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: Container(
                  alignment: Alignment.center,
                  child: const Icon(Iconsax.add, color: Colors.white, size: 24),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildPrescriptionTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: palePeach,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFDF7A4C).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Iconsax.document_text5,
            size: 16,
            color: Color(0xFFDF7A4C),
          ),
          const SizedBox(width: 6),
          const Text(
            'Rx Required',
            style: TextStyle(
              color: Color(0xFFDF7A4C),
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiscountBadge(int discount) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red.shade400, Colors.red.shade600],
        ),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.red.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        '$discount% OFF',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colours.secondaryColor.withOpacity(0.1),
            Colours.secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colours.secondaryColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Iconsax.category5, size: 18, color: Colours.secondaryColor),
          const SizedBox(width: 8),
          Text(
            category,
            style: TextStyle(
              color: Colours.secondaryColor,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(String content) {
    appLog('_buildDescriptionSection - Content: "$content"');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Iconsax.document_text,
                  color: primaryGreen,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Description',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SelectableText(
            content.isEmpty ? 'No description available.' : content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  String _cleanHtmlContent(String content) {
    try {
      // Remove all HTML tags
      String text = content.replaceAll(
        RegExp(r'<[^>]*>', multiLine: true, caseSensitive: false),
        '',
      );

      // Remove xss: attributes and special characters
      text = text.replaceAll(RegExp(r'xss:[^=]*="[^"]*"'), '');
      text = text.replaceAll(RegExp(r'&nbsp;'), ' ');
      text = text.replaceAll(RegExp(r'&quot;'), '"');
      text = text.replaceAll(RegExp(r'&amp;'), '&');
      text = text.replaceAll(RegExp(r'&lt;'), '<');
      text = text.replaceAll(RegExp(r'&gt;'), '>');

      // Remove extra whitespace and trim
      text = text.replaceAll(RegExp(r'\s+'), ' ').trim();

      appLog('_cleanHtmlContent - Cleaned text length: ${text.length}');

      return text;
    } catch (e) {
      appLog('Error cleaning HTML: $e');
      return content;
    }
  }

  Widget _buildImageCarousel(List<String> images) {
    final CarouselSliderController _carouselController =
        CarouselSliderController();
    final safeImages = (images.isEmpty) ? [''] : images;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider.builder(
          carouselController: _carouselController,
          itemCount: safeImages.length,
          itemBuilder: (context, index, realIndex) {
            final img = safeImages[index];
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: img.isEmpty
                    ? Container(
                        color: Colors.grey.shade100,
                        child: Center(
                          child: Icon(
                            Iconsax.gallery,
                            size: 60,
                            color: Colors.grey.shade300,
                          ),
                        ),
                      )
                    : Image.network(
                        resolveUrl(img),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey.shade100,
                            child: Center(
                              child: Icon(
                                Iconsax.gallery,
                                size: 60,
                                color: Colors.grey.shade300,
                              ),
                            ),
                          );
                        },
                      ),
              ),
            );
          },
          options: CarouselOptions(
            height: 280,
            viewportFraction: 0.85,
            enlargeCenterPage: true,
            enlargeFactor: 0.25,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 4),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            enableInfiniteScroll: safeImages.length > 1,
            onPageChanged: (index, reason) {
              setState(() => _pageIndex = index);
            },
          ),
        ),

        const SizedBox(height: 16),

        // Enhanced dots indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(safeImages.length, (index) {
            final bool active = index == _pageIndex;
            return GestureDetector(
              onTap: () => _carouselController.animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: active ? 10 : 8,
                width: active ? 28 : 8,
                decoration: BoxDecoration(
                  gradient: active
                      ? LinearGradient(
                          colors: [primaryGreen, primaryGreen.withOpacity(0.7)],
                        )
                      : null,
                  color: active ? null : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color: primaryGreen.withOpacity(0.4),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
