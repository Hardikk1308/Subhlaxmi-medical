import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension ContextExt on BuildContext {
  ThemeData get theme => Theme.of(this);

  MediaQueryData get mediaQuery => MediaQuery.of(this);

  // AppLocalizations? get localization => AppLocalizations.of(this);

  Size get size => MediaQuery.sizeOf(this);

  double get height => size.height;

  double get width => size.width;

  // Safe Area Dimensions:  Useful for avoiding notches/status bars
  double get safeAreaTop => MediaQuery.of(this).padding.top;
  double get safeAreaBottom => MediaQuery.of(this).padding.bottom;
  double get safeAreaLeft => MediaQuery.of(this).padding.left;
  double get safeAreaRight => MediaQuery.of(this).padding.right;

  // Orientation:  To check if in landscape or portrait
  Orientation get orientation => MediaQuery.of(this).orientation;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  // Platform Brightness: Dark or Light Mode
  Brightness get platformBrightness => MediaQuery.of(this).platformBrightness;
  bool get isDarkMode => platformBrightness == Brightness.dark;
  bool get isLightMode => platformBrightness == Brightness.light;

  // Text Scaling Factor:  How much text is scaled by the user's settings
  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;

  // Device Pixel Ratio: The number of physical pixels for each logical pixel
  double get devicePixelRatio => MediaQuery.of(this).devicePixelRatio;

  // Pixel Density: A more abstract value based on devicePixelRatio
  double get pixelDensity => devicePixelRatio; // You might want to calculate a more specific density category

  // Shortest Side:  Useful for responsive layouts
  double get shortestSide => size.shortestSide;
  bool get isTablet => shortestSide > 600; // Arbitrary threshold for tablet vs phone
  bool get isPhone => !isTablet;

  // Gesture Settings (for more advanced gesture handling)
  EdgeInsets get viewInsets => MediaQuery.of(this).viewInsets;
  EdgeInsets get viewPadding => MediaQuery.of(this).viewPadding;

  // Accessibility Features
  bool get accessibleNavigation => MediaQuery.of(this).accessibleNavigation;
  bool get alwaysUse24HourFormat => MediaQuery.of(this).alwaysUse24HourFormat;
  bool get highContrast => MediaQuery.of(this).highContrast;
  bool get invertColors => MediaQuery.of(this).invertColors;
  bool get reduceMotion => MediaQuery.of(this).disableAnimations; // Use disableAnimations instead of reduceMotion
  bool get boldText => MediaQuery.of(this).boldText;

  // Other Useful Properties

  Locale get locale => Localizations.localeOf(this); // Current locale



}
