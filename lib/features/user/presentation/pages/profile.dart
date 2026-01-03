import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/common/widgets/webview_launcher.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/extentions/color_extensions.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/features/explore/presentation/widgets/gradient_appBar.dart';
import 'package:mediecom/features/orders/presentation/pages/orders.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/domain/entities/user_entity.dart';
import 'package:mediecom/features/user/presentation/blocs/profile/profile_bloc.dart';
import 'package:mediecom/features/user/presentation/pages/detailed_address.dart';
import 'package:mediecom/features/user/presentation/pages/location_fetcher.dart';
import 'package:mediecom/features/user/presentation/pages/update_profile.dart';
import 'package:mediecom/features/user/presentation/widgets/profile_shimmer.dart';
import 'package:mediecom/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  static const path = '/profile';
  const ProfilePage({super.key});

  // Light theme colors inspired by common light modes
  static const Color _primaryLight = Color(0xFFF0F2F5); // Light grey background
  static const Color _cardBackground = Color(
    0xFFFFFFFF,
  ); // White card background
  static const Color _textColor = Color(0xFF212121); // Dark grey text
  static const Color _subtextColor = Color(0xFF757575); // Medium grey text
  static const Color _accentColor = Color(
    0xFF1E88E5,
  ); // A blue accent for active elements
  static const Color _iconColor = Color(0xFF616161);
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final cacheHelper = sl<CacheHelper>();
  @override
  void initState() {
    super.initState();
    final userId = cacheHelper.getUserId();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    context.read<ProfileBloc>().add(GetProfileEvent(userId: userId ?? ""));
    // });
  }

  // Medium grey icon color
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(name: 'Profile', address: '', isUserName: false),
      backgroundColor:
          Colours.primaryBackgroundColour, // Light primary background

      body: SingleChildScrollView(
        // padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  final UserEntity user = state.user;
                  cacheHelper.setIsLoggedIn(true);
                  cacheHelper.cacheUserId(state.user.m2Id ?? "");

                  cacheHelper.cacheUser(user as UserModel);
                  return _buildProfileImage(
                    user.m2Chk1 ?? "name",
                    user.m2Chk2 ?? "email",
                    user.m2Chk20 ?? "",
                  );
                } else if (state is ProfileLoading) {
                  // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   showDialog(
                  //     context: context,
                  //     barrierDismissible: false,
                  //     builder: (_) => const FullScreenLoader(),
                  //   );
                  // });

                  return ProfileShimmer();
                }
                return SizedBox.shrink();
              },
            ),

            SizedBox(height: 30),

            // Profile Sections
            _buildSectionHeader('Account & Settings'),
            const SizedBox(height: 12),
            _buildProfileListItem(
              context,
              title: 'Personal Details',
              icon: Icons.account_circle_outlined,
              onTap: () => context.push(
                UpdateProfileScreen.path,
                extra: {'isFromProfile': true},
              ),
            ),
            _buildProfileListItem(
              context,
              title: 'Order History',
              icon: Icons.history,
              onTap: () => context.go(Orders.path),
            ),
            _buildProfileListItem(
              context,
              title: 'Delivery Addresses',
              icon: Icons.location_on_outlined,
              onTap: () => context.push(AddressesPage.path),
            ),

            const SizedBox(height: 22),

            // _buildSectionHeader('App Preferences'),
            // const SizedBox(height: 12),
            // _buildProfileListItem(
            //   context,
            //   title: 'Notifications',
            //   icon: Icons.notifications_none,
            //   onTap: () => print('Notifications tapped!'),
            // ),
            // _buildProfileListItem(
            //   context,
            //   title: 'Language',
            //   icon: Icons.language,
            //   onTap: () => print('Language tapped!'),
            //   trailingText: 'English',
            // ),
            // _buildProfileListItem(
            //   context,
            //   title: 'Security',
            //   icon: Icons.security,
            //   onTap: () => print('Security tapped!'),
            // ),
            // const SizedBox(height: 32),
            _buildSectionHeader('Support & Legal'),
            const SizedBox(height: 12),
            _buildProfileListItem(
              context,
              title: 'About Us',
              icon: Icons.info,
              onTap: () =>
                  context.push(WebViewScreen.path, extra: ApiConstants.aboutUs),
            ),
            _buildProfileListItem(
              context,
              title: 'Contact Us',
              icon: Icons.call,
              onTap: () =>
                  context.push(WebViewScreen.path, extra: ApiConstants.faq),
            ),
            _buildProfileListItem(
              context,
              title: 'Refund Policy',
              icon: Icons.help_outline,
              onTap: () => context.push(
                WebViewScreen.path,
                extra: ApiConstants.refundPolicy,
              ),
            ),
            _buildProfileListItem(
              context,
              title: 'Privacy Policy',
              icon: Icons.privacy_tip_outlined,
              onTap: () => context.push(
                WebViewScreen.path,
                extra: ApiConstants.privacyPolicy,
              ),
            ),
            _buildProfileListItem(
              context,
              title: 'Terms of Service',
              icon: Icons.description_outlined,
              onTap: () => context.push(
                WebViewScreen.path,
                extra: ApiConstants.termsConditions,
              ),
            ),
            const SizedBox(height: 32),

            // Logout Button
            _buildProfileListItem(
              context,
              title: 'Log Out',
              icon: Icons.logout,
              onTap: () async {
                // Clear all cached data on logout
                await cacheHelper.clearAllCache();
                if (context.mounted) {
                  context.go('/');
                }
              },
              isLogout: true,
            ),
            const SizedBox(height: 20),

            // App Version
            Align(
              alignment: Alignment.center,
              child: Text(
                'App Version 1.0.0',
                style: TextStyle(
                  color: ProfilePage._subtextColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: ProfilePage._cardBackground, // White card background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.1,
            ), // Subtle shadow for light theme
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: ProfilePage._accentColor, size: 24),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: ProfilePage._subtextColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ProfilePage._textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colours.dark, // Muted color for section headers
        ),
      ),
    );
  }

  Widget _buildProfileImage(String name, String email, String imageUrl) {
    // Build complete image URL only if imageUrl is not empty
    final String completeImageUrl = imageUrl.isNotEmpty
        ? '${ApiConstants.profileBase}$imageUrl'
        : '';

    return Container(
      decoration: BoxDecoration(
        color: ProfilePage._cardBackground, // White card background
        // borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
              0.1,
            ), // Subtle shadow for light theme
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Row(
          children: [
            // User Avatar and Name
            Align(
              alignment: Alignment.centerLeft,
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(3), // thickness of the border
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colours.primaryColor, // border color
                        width: 4, // border width
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 40,
                      backgroundColor: Colours.accentCoral.withOpacity(0.1),
                      backgroundImage: completeImageUrl.isNotEmpty
                          ? NetworkImage(completeImageUrl)
                          : null,
                      child: completeImageUrl.isEmpty
                          ? Icon(
                              Icons.person,
                              size: 40,
                              color: Colours.primaryColor,
                            )
                          : null,
                    ),
                  ),
                  // Upload button
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _showImageUploadOptions(),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colours.primaryColor,
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: ProfilePage._textColor,
                  ),
                ),
                Text(
                  email,
                  style: TextStyle(
                    fontSize: 14,
                    color: ProfilePage._subtextColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileListItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
    String? trailingText,
    bool isLogout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 2.0),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8.0),
        decoration: BoxDecoration(
          color: ProfilePage._cardBackground, // White card background
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(
                0.1,
              ), // Subtle shadow for light theme
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListTile(
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: !isLogout
                  ? Colours.primaryBackgroundColour
                  : Colours.error.o10,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isLogout ? Colors.red.shade400 : Colours.primaryColor,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: isLogout ? Colors.red.shade400 : ProfilePage._textColor,
            ),
          ),
          trailing: trailingText != null
              ? Text(
                  trailingText,
                  style: const TextStyle(
                    color: ProfilePage._subtextColor,
                    fontSize: 14,
                  ),
                )
              : Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: !isLogout ? ProfilePage._subtextColor : Colours.white,
                ),
          onTap: onTap,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
        ),
      ),
    );
  }

  void _showImageUploadOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Upload Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take a Photo'),
              onTap: () {
                Navigator.pop(context);
                _uploadImage(true);
              },
            ),
            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _uploadImage(false);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadImage(bool isCamera) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: isCamera ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 80,
      );

      if (image == null) return;

      // Get user ID first
      final userId = cacheHelper.getUserId();
      if (userId == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID not found')),
        );
        return;
      }

      // Show loading dialog
      if (!mounted) return;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (dialogContext) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Upload image using the API
      final success = await _uploadPhotoToAPI(userId, image);

      // Close loading dialog using the main context
      if (!mounted) return;
      Navigator.of(context).pop();

      // Show result
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile picture updated successfully!'),
            duration: Duration(seconds: 2),
          ),
        );
        // Refresh profile after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.read<ProfileBloc>().add(GetProfileEvent(userId: userId));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to upload image'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Upload error: $e');
      if (!mounted) return;
      
      // Try to close dialog if it's open
      try {
        Navigator.of(context).pop();
      } catch (e) {
        print('Error closing dialog: $e');
      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<bool> _uploadPhotoToAPI(String userId, XFile image) async {
    try {
      final uri = Uri.parse(ApiConstants.updatePhoto);
      final request = http.MultipartRequest('POST', uri);

      request.fields['user_id'] = userId;
      request.files.add(
        await http.MultipartFile.fromPath(
          'user_pic',
          image.path,
        ),
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('Upload response status: ${response.statusCode}');
      print('Upload response body: $responseBody');
      
      return response.statusCode == 200;
    } catch (e) {
      print('Upload error: $e');
      return false;
    }
  }
}
