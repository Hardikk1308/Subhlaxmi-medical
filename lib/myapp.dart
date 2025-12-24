import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediecom/core/services/routes/app_router.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/features/account_review/presentation/bloc/account_review_bloc.dart';
import 'package:mediecom/features/account_review/domain/usecases/check_account_status_usecase.dart';
import 'package:mediecom/features/auth/presentation/auth_injection.dart';
import 'package:mediecom/features/auth/presentation/bloc/send_otp/send_otp_bloc.dart';
import 'package:mediecom/features/auth/presentation/bloc/sign_in/sign_in_bloc.dart';
import 'package:mediecom/features/auth/presentation/bloc/verify_otp/verify_otp_bloc.dart';
import 'package:mediecom/features/cart/presentation/blocs/cart_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/features/features_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/product_bloc.dart';
import 'package:mediecom/features/explore/presentation/bloc/search/search_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/banner/banner_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/category/category_bloc.dart';
import 'package:mediecom/features/master/presentation/blocs/sub_category/sub_category_bloc.dart';
import 'package:mediecom/features/notification/data/notifications.dart';
import 'package:mediecom/features/notification/presentation/bloc/notification_bloc.dart';
import 'package:mediecom/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:mediecom/features/user/presentation/blocs/fcm/fcm_bloc.dart';
import 'package:mediecom/features/user/presentation/blocs/profile/profile_bloc.dart';

import 'injection_container.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 800),
      child: MultiBlocProvider(
        providers: [
          ///Auth
          BlocProvider(create: (context) => sl<SignInBloc>()),
          BlocProvider(create: (context) => sl<SendOtpBloc>()),
          BlocProvider(create: (context) => sl<VerifyOtpBloc>()),

          /// Account Review
          BlocProvider(
            create: (context) {
              try {
                return sl<AccountReviewBloc>();
              } catch (e) {
                // If not registered, create a new instance
                return AccountReviewBloc(
                  checkAccountStatusUseCase: sl(),
                );
              }
            },
          ),

          /// BANNERS/SLIDERS
          BlocProvider(create: (context) => sl<BannerBloc>()),

          ///SEARCH
          BlocProvider(create: (context) => sl<SearchBloc>()),

          ///FEATURES
          BlocProvider(create: (context) => sl<FeaturesBloc>()),

          ///CATEGORIES
          BlocProvider(create: (context) => sl<CategoryBloc>()),
          BlocProvider(create: (context) => sl<SubCategoryBloc>()),

          ///USER
          BlocProvider(create: (context) => sl<ProfileBloc>()),

          ///Notification
          BlocProvider(create: (context) => sl<NotificationBloc>()),

          ///Orders
          BlocProvider(create: (context) => sl<OrdersBloc>()),

          ///CART
          BlocProvider(create: (context) => CartBloc()),

          ///CART
          BlocProvider(create: (context) => sl<ProductBloc>()),
          BlocProvider(create: (context) => sl<FcmBloc>()),
        ],
        child: SafeArea(
          bottom: true,
          top: false,
          left: false,
          right: false,
          child: MaterialApp.router(
            title: 'Mediecom',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              scaffoldBackgroundColor: Colours.white,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colours.secondaryColor,
              ),
              useMaterial3: true,
            ),

            builder: (context, child) {
              return AnnotatedRegion<SystemUiOverlayStyle>(
                value: const SystemUiOverlayStyle(
                  statusBarColor: Colours.primaryBackgroundColour,
                  statusBarIconBrightness: Brightness.dark,
                  statusBarBrightness: Brightness.light,
                  systemNavigationBarColor: Colors.white,
                  systemNavigationBarIconBrightness: Brightness.dark,
                ),
                child: child ?? const SizedBox(),
              );
            },

            // home: NavigationScreen(),
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
