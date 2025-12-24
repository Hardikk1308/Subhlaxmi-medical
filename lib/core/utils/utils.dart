import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mediecom/core/common/error/app_failures.dart';
import 'package:mediecom/core/style/app_colors.dart';
// import 'dart:developer';

import 'package:url_launcher/url_launcher.dart';
// import 'package:maps_launcher/maps_launcher.dart';

void launchDialer(String phoneNumber) async {
  final Uri dialUri = Uri(scheme: 'tel', path: phoneNumber);

  if (!await launchUrl(dialUri)) {
    throw "Could not launch dialer";
  }
}

Future<void> openWhatsApp(String phone, String message) async {
  final Uri whatsappUri = Uri.parse(
    "https://wa.me/${phone.replaceAll(" ", "")}?text=${Uri.encodeComponent(message)}",
  );

  if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
    throw "Could not open WhatsApp";
  }
}

Future<void> launchEmail(String email, String subject) async {
  final Uri uri = Uri.parse(
    "mailto:$email?subject=${Uri.encodeComponent(subject)}",
  );

  if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
    debugPrint("Could not launch email client");
  }
}

// Future<void> goToUrl(String? url) async {
//   if (url == null || url.isEmpty) return; // skip empty

//   final Uri uri = Uri.parse(url.trim());

//   if (!uri.hasScheme) {
//     // ensure https:// is added if missing
//     url = "https://$url";
//   }
//   print(await canLaunchUrl(Uri.parse(url)));

//   final Uri safeUri = Uri.parse(url);

//   // if (await canLaunchUrl(safeUri)) {
//   await launchUrl(safeUri, mode: LaunchMode.externalApplication);
//   // } else {
//   // appLog("Could not launch $url");
//   // }
// }

// void launchMap(double lat, double long) async {
//   MapsLauncher.launchCoordinates(lat, long);
// }

// double getAverage(List<String> numbers) {
//   if (numbers.isEmpty) return 0;

//   List<double> doubleList = numbers.map((e) => double.parse(e)).toList();
//   double sum = doubleList.reduce((a, b) => a + b);

//   return sum / doubleList.length;
// }

String mapFailureToMessage(Failure failure) {
  switch (failure) {
    case ServerFailure():
      return 'Server Error: ${failure.message}';
    case NetworkFailure():
      return 'Network Error: ${failure.message}';
    default:
      return 'Unexpected Error';
  }
}

void appLog(String msg) {
  if (kDebugMode) {
    // prints only in debug mode
    // no logs in release builds
    // kDebugMode = true only when debug
    // false in release / profile
    // so safe for production
    // ignore: avoid_print
    log(msg);
  }
}

String resolveUrl(
  String path, {
  String baseUrl = "https://www.subhlaxmimedical.com/myadmin/uploads/product/",
}) {
  if (path.contains("http")) {
    return path; // already a full URL
  } else {
    // remove leading slash if present to avoid double slash
    // final cleanPath = path.startsWith('/') ? path.substring(1) : path;
    appLog("concatedImageUrl$baseUrl$path");
    return "$baseUrl$path";
  }
}

String parseHtmlString(String htmlString) {
  if (htmlString.isEmpty) return '';
  
  try {
    final document = html_parser.parse(htmlString);
    final String parsedString = document.body?.text ?? '';
    return parsedString.trim();
  } catch (e) {
    appLog('Error parsing HTML: $e');
    return htmlString; // Return original string if parsing fails
  }
}

Future<XFile?> showImagePickerSheet(BuildContext context, String title) async {
  final ImagePicker picker = ImagePicker();

  return showModalBottomSheet<XFile?>(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    backgroundColor: Colors.white,
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 4,
                width: 40,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),

              // 🎯 Icon Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOption(
                    icon: Iconsax.camera,
                    color: Colors.blue,
                    label: "Camera",
                    onTap: () async {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.camera,
                      );
                      Navigator.pop(context, image);
                    },
                  ),
                  _buildOption(
                    icon: Iconsax.gallery,
                    color: Colors.green,
                    label: "Gallery",
                    onTap: () async {
                      final XFile? image = await picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      Navigator.pop(context, image);
                    },
                  ),
                  _buildOption(
                    icon: Iconsax.close_circle,
                    color: Colors.red,
                    label: "Cancel",
                    onTap: () => Navigator.pop(context, null),
                  ),
                ],
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      );
    },
  );
}

/// 🔹 Small helper widget for icon buttons
Widget _buildOption({
  required IconData icon,
  required Color color,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(12),
    onTap: onTap,
    child: Column(
      children: [
        Container(
          height: 56,
          width: 56,
          decoration: BoxDecoration(
            border: Border.all(color: color, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade700,
            fontSize: 12,
            fontWeight: FontWeight.w800,
          ),
        ),
      ],
    ),
  );
}
