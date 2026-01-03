import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/core/common/widgets/full_screen_loader.dart';
import 'package:mediecom/core/constants/api_constants.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';
import 'package:mediecom/features/user/data/models/user_model.dart';
import 'package:mediecom/features/user/presentation/blocs/profile/profile_bloc.dart';

import '../../../../injection_container.dart';

class UpdateProfileScreen extends StatefulWidget {
  static const path = '/update-profile';
  final bool isFromProfile;
  
  const UpdateProfileScreen({super.key, this.isFromProfile = false});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final cacheHelper = sl<CacheHelper>();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();

  XFile? _selectedImage;
  String? filePath;

  @override
  void initState() {
    super.initState();
    nameController.text = cacheHelper.getUser()?.m2Chk1 ?? '';
    emailController.text = cacheHelper.getUser()?.m2Chk3 ?? '';
    phoneController.text = cacheHelper.getUser()?.m2Chk2 ?? '';
    addressController.text = cacheHelper.getUser()?.m2Chk7 ?? '';
    referralCodeController.text = cacheHelper.getUser()?.m2Chk25 ?? '';
    filePath = cacheHelper.getUser()?.m2Chk20 ?? '';
  }

  void _onUpdateTapped() {
    final updatedUser = UserModel(
      m2Id: cacheHelper.getUser()?.m2Id,
      m2Chk1: nameController.text.trim(),
      m2Chk2: phoneController.text.trim(),
      m2Chk3: emailController.text.trim(),
      m2Chk7: addressController.text.trim(),
      m2Chk25: referralCodeController.text.trim(),
      // Add other fields as necessary
    );

    context.read<ProfileBloc>().add(
      UpdateProfileEvent(
        params: updatedUser,
        file: _selectedImage != null ? File(_selectedImage!.path) : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
        child: Form(
          key: _formKey,
          child: BlocListener<ProfileBloc, ProfileState>(
            listener: (context, state) {
              if (state is ProfileUpdated) {
                cacheHelper.cacheUser(state.user);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: Colours.success,
                    behavior: SnackBarBehavior.floating,
                    content: Text("Profile Updated Successfully."),
                  ),
                );

                context.go(HomeScreen.path);
              }

              if (state is ProfileLoading) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return FullScreenLoader();
                  },
                );
              }
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.h),

                /// Profile Image Section
                Center(
                  child: Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      CircleAvatar(
                        radius: 55.r,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _selectedImage != null
                            ? FileImage(File(_selectedImage!.path))
                            : filePath != null && filePath!.isNotEmpty
                            ? NetworkImage(
                                    '${ApiConstants.profileBase}$filePath',
                                  )
                                  as ImageProvider
                            : null,
                        // child: _selectedImage == null
                        //     ? const Icon(
                        //         Iconsax.user,
                        //         size: 50,
                        //         color: Colors.grey,
                        //       )
                        //     : null,
                      ),
                      InkWell(
                        onTap: () async {
                          final XFile? image = await showImagePickerSheet(
                            context,
                            'Select Profile Photo',
                          );
                          if (image != null) {
                            setState(() => _selectedImage = image);
                          }
                        },
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colours.primaryColor,
                          child: const Icon(
                            Iconsax.camera,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 10.h),
                Text(
                  "Change Photo",
                  style: TextStyle(
                    color: Colours.primaryColor,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 30.h),

                /// Full Name
                _buildLabel('Full Name'),
                _buildTextField(
                  controller: nameController,
                  hintText: 'Enter your name',
                  icon: Iconsax.user,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your full name';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                /// Email
                _buildLabel('Email Address'),
                _buildTextField(
                  controller: emailController,
                  hintText: 'Enter your email',
                  icon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your email';
                    }
                    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                /// Phone
                _buildLabel('Phone Number'),
                IgnorePointer(
                  ignoring: true,
                  child: _buildTextField(
                    controller: phoneController,
                    hintText: 'Enter phone number',
                    icon: Iconsax.call,
                    keyboardType: TextInputType.phone,
                  ),
                ),

                SizedBox(height: 20.h),

                /// Address
                _buildLabel('Shipping Address'),
                _buildTextField(
                  controller: addressController,
                  hintText: 'Enter shipping address',
                  icon: Iconsax.truck,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your shipping address';
                    }
                    return null;
                  },
                ),

                SizedBox(height: 20.h),

                /// Referral Code
                _buildLabel('Referral Code'),
                _buildTextField(
                  controller: referralCodeController,
                  hintText: 'Enter referral code',
                  icon: Iconsax.gift,
                  readOnly: widget.isFromProfile,
                ),

                SizedBox(height: 40.h),

                /// Save Button
                SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _onUpdateTapped();
                      }
                    },
                    child: Text(
                      'Save Changes',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Label
  Widget _buildLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 6.h),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  /// TextFormField with Validator
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, size: 20, color: Colors.grey.shade700),
        hintText: hintText,
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
