import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:mediecom/core/extentions/text_style_extentions.dart';
import 'package:mediecom/core/style/app_colors.dart';
import 'package:mediecom/core/style/app_text_styles.dart';
import 'package:mediecom/features/notification/presentation/pages/notification.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String name;
  final String address;
  // final VoidCallback? onNotificationTap;
  final bool isUserName;
  final ValueChanged<String>? onSearchChanged;
  final bool leading;

  const GradientAppBar({
    super.key,
    required this.name,
    required this.address,
    // this.onNotificationTap,
    required this.isUserName,
    this.onSearchChanged,
    this.leading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: preferredSize.height,
      // color: Colours.primaryBackgroundColour,/
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colours.primaryBackgroundColour,
            Colours.primaryBackgroundColour,
            // Colours.primaryColor,
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
                leading
                    ? IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colours.dark,
                          size: 18,
                        ),
                        onPressed: () => Navigator.pop(context),
                      )
                    : SizedBox.shrink(),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isUserName) ...[
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
                                address,
                                style: AppTextStyles.w400(10),
                              ),
                            ),
                          ],
                        ),
                      ],
                      if (!isUserName) ...[
                        Flexible(
                          child: Text(
                            name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.w800(16).primary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
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
            if (isUserName) ...[
              const SizedBox(height: 12),
              // Search Bar
              TextField(
                onChanged: onSearchChanged,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colours.white,
                  enabled: true,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colours.primaryColor, // no visible border
                      width: 0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colours.primaryColor, // highlight when focused
                      width: 1.5,
                    ),
                  ),

                  hintText: "Search medicines, brands...",
                  hintStyle: AppTextStyles.w600(14),
                  prefixIcon: const Icon(
                    Iconsax.search_normal,
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(isUserName ? 160 : 108);
}
