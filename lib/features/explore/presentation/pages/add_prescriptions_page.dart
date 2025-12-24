import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/utils/utils.dart';
import 'package:mediecom/features/explore/presentation/pages/process_request_page.dart';

class UploadPrescriptionPage extends StatefulWidget {
  static const path = '/upload-prescription';

  const UploadPrescriptionPage({super.key});

  @override
  State<UploadPrescriptionPage> createState() => _UploadPrescriptionPageState();
}

class _UploadPrescriptionPageState extends State<UploadPrescriptionPage> {
  List<XFile> selectedImages = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10.h),

            Text(
              "Upload Prescriptions",
              style: TextStyle(
                fontSize: 24.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 6.h),

            Text(
              "and let us arrange your medicines for you",
              style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40.h),

            buildImageSection(),

            SizedBox(height: 40.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  onPressed: selectedImages.length >= 3
                      ? null
                      : () async {
                          final XFile? image = await showImagePickerSheet(
                            context,
                            'Upload Prescription',
                          );
                          if (image != null) {
                            setState(() => selectedImages.add(image));
                          }
                        },
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colours.primaryBackgroundColour,
                    side: const BorderSide(
                      color: Colours.primaryColor,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    selectedImages.isEmpty
                        ? "Upload Prescription"
                        : "Add More (${selectedImages.length}/3)",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: Colours.primaryColor,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            /// Continue Button
            if (selectedImages.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: SizedBox(
                  width: double.infinity,
                  height: 55.h,
                  child: ElevatedButton(
                    onPressed: () => context.push(
                      ProcessRequestPage.path,
                      extra: selectedImages, // <-- send list of images
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colours.primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Continue",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

            SizedBox(height: 20.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Text(
                "All uploads are encrypted & visible only to our pharmacists. "
                "Any prescription you upload is validated before processing the order.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  /// ------------------------------
  /// IMAGE PREVIEW (1 to 3 images)
  /// ------------------------------
  Widget buildImageSection() {
    if (selectedImages.isEmpty) {
      return Container(
        width: 180.w,
        height: 180.w,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Image.asset("assets/images/document.png", height: 100),
        ),
      );
    }

    return SizedBox(
      height: 180.w,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        itemCount: selectedImages.length,
        separatorBuilder: (_, __) => SizedBox(width: 15.w),
        itemBuilder: (context, index) {
          return Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
                child: Image.file(
                  File(selectedImages[index].path),
                  width: 180.w,
                  height: 180.w,
                  fit: BoxFit.cover,
                ),
              ),

              /// Remove Button
              Positioned(
                top: 8,
                right: 8,
                child: InkWell(
                  onTap: () {
                    setState(() => selectedImages.removeAt(index));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.black54,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
