import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/features/cart/presentation/pages/cart.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';
import 'package:mediecom/features/orders/presentation/pages/orders.dart';
import 'package:mediecom/features/user/presentation/pages/profile.dart';

import '../../../injection_container.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key, required this.child});

  final Widget child;
  static const path = "/navigation_screen";

  @override
  Widget build(BuildContext context) {
    final int selectedIndex = _calculateSelectedIndex(context);
    final cacheHelper = sl<CacheHelper>();
    final user = cacheHelper.getUser();

    final String userAddress = user!.m2Chk7 ?? "address";

    return Scaffold(
      body: child,

      bottomNavigationBar: BottomAppBar(
        height: 69.h,
        color: Colours.white,
        notchMargin: 5,
        shape: CircularNotchedRectangle(inverted: false),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _onItemTapped(0, context);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Iconsax.home_1,
                    color: selectedIndex == 0
                        ? Colours.primaryColor
                        : Colours.neutralGray,
                  ),
                  Text(
                    "Home",
                    style: AppTextStyles.w700(12).copyWith(
                      color: selectedIndex == 0
                          ? Colours.primaryColor
                          : Colours.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _onItemTapped(1, context);
              },
              child: Column(
                children: [
                  Icon(
                    Iconsax.shopping_cart,
                    color: selectedIndex == 1
                        ? Colours.primaryColor
                        : Colours.neutralGray,
                  ),
                  Text(
                    "Cart",
                    style: AppTextStyles.w700(12).copyWith(
                      color: selectedIndex == 1
                          ? Colours.primaryColor
                          : Colours.neutralGray,
                    ),
                  ),
                ],
              ),
            ),

            InkWell(
              onTap: () {
                _onItemTapped(2, context);
              },
              child: Column(
                children: [
                  Icon(
                    Iconsax.receipt,
                    color: selectedIndex == 2
                        ? Colours.primaryColor
                        : Colours.neutralGray,
                  ),
                  Text(
                    "Orders",
                    style: AppTextStyles.w700(12).copyWith(
                      color: selectedIndex == 2
                          ? Colours.primaryColor
                          : Colours.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              onTap: () {
                _onItemTapped(3, context);
              },
              child: Column(
                children: [
                  Icon(
                    Iconsax.profile_2user,
                    color: selectedIndex == 3
                        ? Colours.primaryColor
                        : Colours.neutralGray,
                  ),
                  Text(
                    "Profile",
                    style: AppTextStyles.w700(12).copyWith(
                      color: selectedIndex == 3
                          ? Colours.primaryColor
                          : Colours.neutralGray,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

int _calculateSelectedIndex(BuildContext context) {
  final GoRouter router = GoRouter.of(context);
  final String location = router.routerDelegate.currentConfiguration.uri
      .toString();

  if (location.startsWith(HomeScreen.path)) {
    return 0;
  }
  if (location.startsWith(Cart.path)) {
    return 1;
  }
  if (location.startsWith(Orders.path)) {
    return 2;
  }
  if (location.startsWith(ProfilePage.path)) {
    return 3;
  }

  return 0;
}

void _onItemTapped(int index, BuildContext context) {
  switch (index) {
    case 0:
      context.go(HomeScreen.path);
      break;
    case 1:
      context.go(Cart.path);
      break;
    case 2:
      context.go(Orders.path);
      break;
    case 3:
      context.go(ProfilePage.path);
      break;
  }
}

String _getTitle(BuildContext context) {
  final int index = _calculateSelectedIndex(context);
  final cacheHelper = sl<CacheHelper>();
  final user = cacheHelper.getUser();

  if (index == 0) {
    // Home tab selected, show greeting based on time of day
    return user!.m2Chk1 ?? "UserName";
  } else if (index == 1) {
    return "Cart";
  } else if (index == 2) {
    return "Orders";
  } else if (index == 3) {
    return "Profile";
  }
  return '';
}
