import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/account_review/presentation/bloc/account_review_bloc.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/user/presentation/pages/location_fetcher.dart';
import 'package:mediecom/features/user/presentation/pages/update_profile.dart';
import 'package:mediecom/injection_container.dart';

class AccountReviewData {
  final String logo;
  final String companyName;
  final String description;
  final String contactNumber;
  final String userId;

  AccountReviewData({
    required this.logo,
    required this.companyName,
    required this.description,
    required this.contactNumber,
    required this.userId,
  });
}

class AccountReviewPage extends StatefulWidget {
  static const path = '/account-review';
  final AccountReviewData data;

  const AccountReviewPage({super.key, required this.data});

  @override
  State<AccountReviewPage> createState() => _AccountReviewPageState();
}

class _AccountReviewPageState extends State<AccountReviewPage> {
  @override
  void initState() {
    super.initState();
    // Start polling for account status - use Future.microtask to ensure BLoC is available
    Future.microtask(() {
      try {
        if (mounted) {
          final bloc = context.read<AccountReviewBloc>();
          bloc.add(StartPollingEvent(userId: widget.data.userId));
        }
      } catch (e) {
        print('Error starting polling: $e');
      }
    });
  }

  @override
  void dispose() {
    try {
      context.read<AccountReviewBloc>().add(const StopPollingEvent());
    } catch (e) {
      print('Error stopping polling: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        // Prevent back button from closing the app
        // User must wait for account approval
        if (didPop) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please wait for your account to be approved'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: GradientAppBar(
          name: "Account Review",
          address: "address",
          isUserName: false,
          leading: false,
        ),
        body: BlocListener<AccountReviewBloc, AccountReviewState>(
          listener: (context, state) {
            if (state is AccountReviewApproved) {
              _handleAccountApproved(context);
            } else if (state is AccountReviewRejected) {
              _handleAccountRejected(context, state.reason);
            }
          },
          child: BlocBuilder<AccountReviewBloc, AccountReviewState>(
            builder: (context, state) {
              if (state is AccountReviewLoading) {
                return const Center(
                  child: CircularProgressIndicator(color: Colours.primaryColor),
                );
              }

              if (state is AccountReviewError) {
                return _buildErrorWidget(context, state.message);
              }

              if (state is AccountReviewApproved) {
                return _buildApprovedWidget();
              }

              if (state is AccountReviewRejected) {
                return _buildRejectedWidget(state.reason);
              }

              // Show under review or polling state
              return SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 40.h),
                    _buildLogoSection(),
                    SizedBox(height: 32.h),
                    _buildCompanyNameSection(),
                    SizedBox(height: 24.h),
                    _buildDescriptionSection(state),
                    SizedBox(height: 32.h),
                    _buildContactSection(),
                    SizedBox(height: 40.h),
                  ],
                ),
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: _buildContactButton(context),
      ),
    );
  }

  void _handleAccountApproved(BuildContext context) {
    // Stop polling immediately
    try {
      context.read<AccountReviewBloc>().add(const StopPollingEvent());
    } catch (e) {
      print('Error stopping polling: $e');
    }

    // Navigate immediately to update profile page
    _navigateToNextPage(context);
  }

  void _handleAccountRejected(BuildContext context, String reason) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Account Rejected'),
        content: Text(reason),
        actions: [
          TextButton(onPressed: () => context.pop(), child: const Text('OK')),
        ],
      ),
    );
  }

  void _navigateToNextPage(BuildContext context) {
    final cacheHelper = sl<CacheHelper>();
    final hasLat = cacheHelper.getLatitude();
    final hasLng = cacheHelper.getLongitude();

    // After account approval, always go to fill details page first
    context.go(UpdateProfileScreen.path);
  }

  Widget _buildErrorWidget(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Iconsax.info_circle, size: 64, color: Colors.grey[400]),
          SizedBox(height: 16.h),
          Text(
            'Error',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () {
              context.read<AccountReviewBloc>().add(
                CheckAccountStatusEvent(userId: widget.data.userId),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colours.primaryColor,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovedWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.tick_circle5,
              size: 80,
              color: Color(0xFF10B981),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Account Approved!',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'Your account has been successfully approved.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 32.h),
          const CircularProgressIndicator(color: Colours.primaryColor),
          SizedBox(height: 12.h),
          Text(
            'Redirecting...',
            style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildRejectedWidget(String reason) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFFFEE2E2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.close_circle5,
              size: 80,
              color: Color(0xFFEF4444),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'Account Rejected',
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              reason,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
                height: 1.5,
              ),
            ),
          ),
          SizedBox(height: 32.h),
          ElevatedButton(
            onPressed: () => launchDialer(widget.data.contactNumber),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colours.primaryColor,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
            ),
            child: const Text('Contact Support'),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(AccountReviewState state) {
    String statusText = 'Your Account Is In An Under Review.';
    int? checkCount;

    if (state is AccountReviewPolling) {
      checkCount = state.checkCount;
      statusText = 'Checking for updates...';
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7).withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Iconsax.clock,
              size: 40,
              color: Color(0xFFF59E0B),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            statusText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              color: const Color(0xFF4B5563),
              height: 1.6,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (checkCount != null && checkCount > 0) ...[
            SizedBox(height: 12.h),
            Text(
              'Checked ${checkCount} time${checkCount > 1 ? 's' : ''}',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[500]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLogoSection() {
    return Container(
      width: 120.w,
      height: 120.w,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.network(
          widget.data.logo,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Colours.primaryColor.withOpacity(0.1),
              child: const Icon(
                Iconsax.building_3,
                color: Colours.primaryColor,
                size: 48,
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCompanyNameSection() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Text(
        widget.data.companyName,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 24.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF1A1A1A),
          height: 1.3,
        ),
      ),
    );
  }

  Widget _buildContactSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Need Help?',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'If you have any questions about your account review, please contact us:',
            style: TextStyle(
              fontSize: 13.sp,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!, width: 1),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colours.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Iconsax.call,
                    size: 18,
                    color: Colours.primaryColor,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contact Number',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        widget.data.contactNumber,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      width: double.infinity,
      height: 56.h,
      child: ElevatedButton(
        onPressed: () => launchDialer(widget.data.contactNumber),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colours.primaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Iconsax.call_calling, color: Colors.white),
            SizedBox(width: 8.w),
            Text(
              "Contact Support",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
