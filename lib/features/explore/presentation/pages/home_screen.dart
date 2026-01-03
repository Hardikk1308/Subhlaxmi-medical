import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/common/widgets/safe_lottie_loader.dart';
import 'package:mediecom/core/constants/media_constants.dart';
import 'package:mediecom/core/extentions/text_style_extentions.dart';
import 'package:mediecom/core/services/routes/arguments/product_details.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_state.dart';
import 'package:mediecom/features/cart/presentation/pages/cart.dart';
import 'package:mediecom/features/explore/domain/entities/product_entity.dart';
import 'package:mediecom/features/explore/presentation/bloc/features/features_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/product_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/search/search_bloc.dart';
import 'package:mediecom/features/explore/presentation/pages/add_prescriptions_page.dart';
import 'package:mediecom/features/explore/presentation/pages/product_details.dart';
import 'package:mediecom/features/explore/presentation/widgets/category_shimmers.dart';
import 'package:mediecom/features/explore/presentation/widgets/featured_widget.dart';
import 'package:mediecom/features/explore/presentation/widgets/floating_button.dart';
import 'package:mediecom/features/explore/presentation/widgets/products.dart';
import 'package:mediecom/features/explore/presentation/widgets/top_banner_shimmer.dart';
import 'package:mediecom/features/explore/presentation/widgets/top_banners.dart';
import 'package:mediecom/features/master/presentation/blocs/banner/banner_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/category/category_bloc.dart';
import 'package:mediecom/features/notification/presentation/pages/notification.dart';
import 'package:mediecom/features/user/presentation/blocs/fcm/fcm_bloc.dart';
import 'package:mediecom/injection_container.dart';

class HomeScreen extends StatefulWidget {
  static const path = '/home-screen';
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = sl<CacheHelper>().getFcmToken();
      final user = sl<CacheHelper>().getUser();

      if (user != null && token != null) {
        context.read<FcmBloc>().add(
          AddFcmEvent(fcm: token, userId: user.m2Id ?? ""),
        );
      }
    });

    context.read<BannerBloc>().add(FetchBannerEvent());
    context.read<FeaturesBloc>().add(FetchFeaturesEvent());
    context.read<CategoryBloc>().add(FetchCategoryEvent());
    context.read<ProductBloc>().add(FetchProducts());

    _searchController.addListener(() {
      setState(() {
        _isSearching = _searchController.text.isNotEmpty;
      });

      if (_debounce?.isActive ?? false) _debounce!.cancel();

      _debounce = Timer(const Duration(milliseconds: 500), () {
        final query = _searchController.text;

        if (query.isNotEmpty) {
          context.read<SearchBloc>().add(PerformSearchEvent(query: query));
        }
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
    _debounce?.cancel();
  }

  Future<dynamic> onCallTapped() {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colours.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        final cacheHelper = sl<CacheHelper>();
        final appData = cacheHelper.getApplicationData();
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "Contact Us",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 20),

              // 📞 Call Button
              ListTile(
                leading: const Icon(Icons.phone, color: Colors.green),
                title: const Text("Call Us"),
                onTap: () {
                  // Launch dialer
                  launchDialer(appData!.contactNumber ?? "1234567890");
                },
              ),

              // 💬 WhatsApp Button
              ListTile(
                leading: Image.asset(
                  "assets/images/whatsapp.png",
                  height: 20,
                  width: 20,
                ),
                title: const Text("Chat on WhatsApp"),
                onTap: () async {
                  openWhatsApp(
                    "+91 ${appData!.contactNumber}",
                    "I have a query regarding...",
                  );
                },
              ),

              // 📧 Email Button
              ListTile(
                leading: const Icon(Icons.email, color: Colors.blue),
                title: const Text("Email Us"),
                onTap: () {
                  launchEmail("${appData!.email}", "App%20Support%20Request");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAppBar() {
    final cacheHelper = sl<CacheHelper>();
    final user = cacheHelper.getUser();
    final name = user?.m2Chk1 ?? "User";
    final address = user?.m2Chk7 ?? "No Address Available";

    final fullAddress = cacheHelper.getFullAddress();

    // final prefs = await SharedPreferences.getInstance();

    return Container(
      height: 161.h, // Adjust height as needed
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colours.primaryBackgroundColour,
            Colours.primaryBackgroundColour,
            Colours.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Name/Address + Notification
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hi, $name 👋",
                        style: const TextStyle(
                          color: Colours.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Iconsax.location5,
                            size: 14,
                            color: Colours.primaryColor,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              fullAddress ?? "Address",
                              style: AppTextStyles.w400(10),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    // Make sure NotificationPage is imported
                    context.push(NotificationPage.path);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Iconsax.notification, size: 18),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Search Bar
            TextField(
              controller: _searchController,
              focusNode: _searchFocusNode,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colours.white,
                enabled: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colours.primaryColor,
                    width: 0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: Colours.primaryColor,
                    width: 1.5,
                  ),
                ),
                hintText: "Search medicines, brands...",
                hintStyle: AppTextStyles.w600(14),
                prefixIcon: const Icon(
                  Iconsax.search_normal,
                  color: Colors.grey,
                ),
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          _searchFocusNode.unfocus();
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults() {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search Results for "${_searchController.text}"',
            style: AppTextStyles.w700(16).black,
          ),
          SizedBox(height: 16.h),

          BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoading) {
                return SizedBox(
                  height: 200.h,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colours.primaryColor,
                    ),
                  ),
                );
              }
              if (state is SearchLoaded) {
                final products = state.products;

                if (products.isEmpty) {
                  return SizedBox(
                    height: 200.h,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Iconsax.search_normal,
                            size: 48.sp,
                            color: Colors.grey[400],
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            'No results found',
                            style: AppTextStyles.w600(
                              14,
                            ).copyWith(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.55,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 10,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final ProductEntity product = products[index];
                    return GestureDetector(
                      onTap: () {
                        context.push(
                          ProductDetailPage.path,
                          extra: ProductDetailsArgs(
                            cate: product,
                            tag: "product_card_${product.M1_CODE}_$index",
                          ),
                        );
                      },
                      child: ProductCard(data: product, index: index),
                    );
                  },
                );
              }
              if (state is SearchError) {
                return SizedBox(
                  height: 200.h,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Iconsax.warning_2,
                          size: 48.sp,
                          color: Colors.red[400],
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'Error loading results',
                          style: AppTextStyles.w600(
                            14,
                          ).copyWith(color: Colors.red[600]),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          state.message,
                          style: AppTextStyles.w400(
                            12,
                          ).copyWith(color: Colors.grey[600]),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return Column(
      children: [
        BlocBuilder<BannerBloc, BannerState>(
          builder: (context, state) {
            if (state is BannerSuccess) {
              final data = state.banners;
              return TopBannerCarousel(imageUrls: data);
            }
            if (state is BannerLoading) {
              return TopBannerShimmer();
            }
            return SizedBox.shrink();
          },
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            children: [
              Text("Quick Actions", style: AppTextStyles.w700(16).black),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          height: 135.h,
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => context.push(UploadPrescriptionPage.path),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colours.primaryColor),
                      color: Colors.yellow.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SafeLottie(
                          asset: AppMedia.lottiePresciption,
                          height: 50.h,
                          width: 50.h,
                        ),
                        Center(
                          child: Text(
                            "Order With\nPrescription",
                            style: AppTextStyles.w800(12).primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: GestureDetector(
                  onTap: onCallTapped,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colours.primaryColor),
                      color: Colors.yellow.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        SafeLottie(
                          asset: AppMedia.lottieCalling,
                          height: 50.h,
                          width: 50.h,
                        ),
                        Text(
                          "Call to order\nmedicine",
                          style: AppTextStyles.w800(12).primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 8.h),

        //  start from here
        BlocBuilder<FeaturesBloc, FeaturesState>(
          builder: (context, state) {
            if (state is FeaturesLoaded) {
              final data = state.featuresEntity;

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  return FeaturedWidget(feature: data[index]);
                },
              );
            }
            if (state is FeaturesLoading) {
              return CategoryShimmer();
            }
            return SizedBox.shrink();
          },
        ),
        SizedBox(height: 8.h),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.h),
        child: _buildAppBar(),
      ),

      // backgroundColor: Colours.secondaryBackgroundColour,
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

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 100.0),
          child: _isSearching ? _buildSearchResults() : _buildHomeContent(),
        ),
      ),
    );
  }
}
