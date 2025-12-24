import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:mediecom/core/common/app/cache_helper.dart';
import 'package:mediecom/features/explore/presentation/pages/home_screen.dart';
import 'package:mediecom/injection_container.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationResult {
  final double lat;
  final double lng;
  final String city;
  final String district;
  final String fullAddress;

  LocationResult({
    required this.lat,
    required this.lng,
    required this.city,
    required this.district,
    required this.fullAddress,
  });

  Map<String, dynamic> toMap() => {
    'lat': lat,
    'lng': lng,
    'city': city,
    'district': district,
    'fullAddress': fullAddress,
  };
}

class LocationPage extends StatefulWidget {
  static const String path = '/location_fetcher';
  const LocationPage({super.key});

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulse;

  bool _isLoading = true;
  String _statusText = "Initializing...";
  String? _error;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulse = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Auto-fetch location on page load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchLocation();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _fetchLocation() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _statusText = "Checking location services...";
    });

    try {
      // 1. Check location service
      if (!await Geolocator.isLocationServiceEnabled()) {
        setState(() {
          _error = "Location services are disabled.";
          _statusText = "Please enable location services";
          _isLoading = false;
        });
        return;
      }

      setState(() => _statusText = "Requesting permission...");

      // 2. Check permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _error = "Location permission denied.";
            _statusText = "Permission required to continue";
            _isLoading = false;
          });
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = "Enable location in app settings.";
          _statusText = "Check your app settings";
          _isLoading = false;
        });
        return;
      }

      setState(() => _statusText = "Getting your location...");

      // 3. Get coordinates
      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );

      setState(() => _statusText = "Finding your address...");

      // 4. Reverse geocode
      final placemarks = await placemarkFromCoordinates(
        pos.latitude,
        pos.longitude,
      );
      final p = placemarks.first;

      final city = p.locality ?? "";
      final district = p.subAdministrativeArea ?? p.administrativeArea ?? "";
      final fullAddress = [
        p.street,
        p.locality,
        p.administrativeArea,
        p.postalCode,
      ].where((e) => e != null && e.trim().isNotEmpty).join(", ");

      final result = LocationResult(
        lat: pos.latitude,
        lng: pos.longitude,
        city: city,
        district: district,
        fullAddress: fullAddress,
      );

      setState(() => _statusText = "Location found!");

      // // 5. Save to SharedPreferences

      final cacheHelper = sl<CacheHelper>();
      cacheHelper.cacheLatitude(result.lat);
      cacheHelper.cacheLongitude(result.lng);
      cacheHelper.cacheLocationDetails(
        city: result.city,
        district: result.district,
      );
      cacheHelper.cacheFullAddress(address: result.fullAddress);

      // Small delay to show success message
      await Future.delayed(const Duration(milliseconds: 800));

      if (mounted) {
        context.go(HomeScreen.path);
      }
    } catch (e) {
      log("Location error: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = "Unable to fetch location. Please try again.";
          _statusText = "Something went wrong";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F4F6),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFFE0F4F6),
              const Color(0xFFEBF7FF),
              const Color(0xFFF1FAFE),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const Spacer(),

                // Animated location icon with rings
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Outer ring
                    ScaleTransition(
                      scale: _pulse,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF007B7F).withOpacity(0.1),
                              const Color(0xFF1CA7E0).withOpacity(0.1),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Middle ring
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF007B7F).withOpacity(0.15),
                            const Color(0xFF1CA7E0).withOpacity(0.15),
                          ],
                        ),
                      ),
                    ),
                    // Inner circle with icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF007B7F), Color(0xFF1CA7E0)],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF007B7F).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.location_on_rounded,
                        size: 60,
                        color: Color(0xFFFFFFFF),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 48),

                // Title
                const Text(
                  "Finding Your Location",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    letterSpacing: -0.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 12),

                // Status text
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: Text(
                    _statusText,
                    key: ValueKey(_statusText),
                    style: TextStyle(
                      fontSize: 15,
                      color: _error != null
                          ? const Color(0xFFE53935)
                          : const Color(0xFFA9A9A9),
                      height: 1.5,
                      fontWeight: _error != null
                          ? FontWeight.w500
                          : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

                const SizedBox(height: 40),

                // Error message with retry button
                if (_error != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE53935).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE53935).withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.error_outline_rounded,
                              color: Color(0xFFE53935),
                              size: 22,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                _error!,
                                style: const TextStyle(
                                  color: Color(0xFFE53935),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF007B7F),
                              foregroundColor: const Color(0xFFFFFFFF),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                            onPressed: _fetchLocation,
                            child: const Text(
                              "Try Again",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Loading indicator
                  const SizedBox(
                    height: 32,
                    width: 32,
                    child: CircularProgressIndicator(
                      color: Color(0xFF007B7F),
                      strokeWidth: 3,
                    ),
                  ),
                ],

                const Spacer(),

                // Privacy note
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_outline_rounded,
                        size: 16,
                        color: const Color(0xFFA9A9A9),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Your location data is secure and private",
                        style: TextStyle(
                          fontSize: 12,
                          color: const Color(0xFFA9A9A9),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
