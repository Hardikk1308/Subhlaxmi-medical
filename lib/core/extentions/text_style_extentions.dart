import 'package:flutter/material.dart';
import 'package:mediecom/core/extentions/color_extensions.dart';
import '../style/app_colors.dart';

extension TextStyleExt on TextStyle {
  TextStyle get primary => copyWith(color: Colours.primaryColor);
  TextStyle get secondary => copyWith(color: Colours.secondaryColor);
  TextStyle get tertiary => copyWith(color: Colours.accentCoral);

  TextStyle get black => copyWith(color: Colors.black);
  TextStyle get dark => copyWith(color: Colours.dark);
  TextStyle get white => copyWith(color: Colors.white);

  TextStyle get grey => copyWith(color: Colours.neutralGray);
  TextStyle get lightGrey => copyWith(color: Colours.white);

  TextStyle get green => copyWith(color: Colours.success);
  TextStyle get red => copyWith(color: Colours.error);
  TextStyle get blue => copyWith(color: Colours.info);
}

// Opacity extension on TextStyle
extension TextStyleOpacityExt on TextStyle {
  TextStyle get o5 => copyWith(color: color?.o5);
  TextStyle get o10 => copyWith(color: color?.o10);
  TextStyle get o15 => copyWith(color: color?.o15);
  TextStyle get o20 => copyWith(color: color?.o20);
  TextStyle get o25 => copyWith(color: color?.o25);
  TextStyle get o30 => copyWith(color: color?.o30);
  TextStyle get o35 => copyWith(color: color?.o35);
  TextStyle get o40 => copyWith(color: color?.o40);
  TextStyle get o45 => copyWith(color: color?.o45);
  TextStyle get o50 => copyWith(color: color?.o50);
  TextStyle get o55 => copyWith(color: color?.o55);
  TextStyle get o60 => copyWith(color: color?.o60);
  TextStyle get o65 => copyWith(color: color?.o65);
  TextStyle get o70 => copyWith(color: color?.o70);
  TextStyle get o75 => copyWith(color: color?.o75);
  TextStyle get o80 => copyWith(color: color?.o80);
  TextStyle get o85 => copyWith(color: color?.o85);
  TextStyle get o90 => copyWith(color: color?.o90);
  TextStyle get o95 => copyWith(color: color?.o95);
}
// import 'package:flutter/material.dart';

// import '../style/app_colors.dart';

// extension TextStyleExt on TextStyle {
//   // Primary Colors
//   TextStyle get primary100 => copyWith(color: Colours.primary100Colour);
//   TextStyle get primary80 => copyWith(color: Colours.primary80Colour);
//   TextStyle get primary60 => copyWith(color: Colours.primary60Colour);
//   TextStyle get primary40 => copyWith(color: Colours.primary40Colour);
//   TextStyle get primary20 => copyWith(color: Colours.primary20Colour);

//   // Primary Colors
//   TextStyle get secondary100 => copyWith(color: Colours.secondary100Colour);
//   TextStyle get secondary80 => copyWith(color: Colours.secondary80Colour);
//   TextStyle get secondary60 => copyWith(color: Colours.secondary60Colour);
//   TextStyle get secondary40 => copyWith(color: Colours.secondary40Colour);
//   TextStyle get secondary20 => copyWith(color: Colours.secondary20Colour);

//   // Primary Colors
//   TextStyle get tertiary100 => copyWith(color: Colours.tertiary100Colour);
//   TextStyle get tertiary80 => copyWith(color: Colours.tertiary80Colour);
//   TextStyle get tertiary60 => copyWith(color: Colours.tertiary60Colour);
//   TextStyle get tertiary40 => copyWith(color: Colours.tertiary40Colour);
//   TextStyle get tertiary20 => copyWith(color: Colours.tertiary20Colour);

//   // Black Colors
//   TextStyle get black => copyWith(color: Colours.blackColour);
//   TextStyle get black80 => copyWith(color: Colours.black80Colour);
//   TextStyle get black60 => copyWith(color: Colours.black60Colour);
//   TextStyle get black40 => copyWith(color: Colours.black40Colour);
//   TextStyle get black20 => copyWith(color: Colours.black20Colour);

//   // Dark Colors
//   TextStyle get dark100 => copyWith(color: Colours.dark100Colour);
//   TextStyle get dark80 => copyWith(color: Colours.dark80Colour);
//   TextStyle get dark60 => copyWith(color: Colours.dark60Colour);
//   TextStyle get dark40 => copyWith(color: Colours.dark);
//   TextStyle get dark20 => copyWith(color: Colours.dark20Colour);

//   // White Colors
//   TextStyle get white => copyWith(color: Colours.white);
//   TextStyle get white80 => copyWith(color: Colours.white80Colour);
//   TextStyle get white60 => copyWith(color: Colours.white60Colour);
//   TextStyle get white40 => copyWith(color: Colours.white40Colour);
//   TextStyle get white20 => copyWith(color: Colours.white20Colour);

//   // Grey Colors
//   TextStyle get grey100 => copyWith(color: Colours.grey100Colour);
//   TextStyle get grey80 => copyWith(color: Colours.grey80Colour);
//   TextStyle get grey60 => copyWith(color: Colours.grey60Colour);
//   TextStyle get grey40 => copyWith(color: Colours.grey40Colour);
//   TextStyle get grey20 => copyWith(color: Colours.grey20Colour);

//   // Light Grey Colors
//   TextStyle get lightGrey100 => copyWith(color: Colours.neutralGray);
//   TextStyle get lightGrey80 => copyWith(color: Colours.lightGrey80Colour);
//   TextStyle get lightGrey60 => copyWith(color: Colours.lightGrey60Colour);
//   TextStyle get lightGrey40 => copyWith(color: Colours.lightGrey40Colour);
//   TextStyle get lightGrey20 => copyWith(color: Colours.lightGrey20Colour);

//   // Green Colors
//   TextStyle get green100 => copyWith(color: Colours.green100Colour);
//   TextStyle get green80 => copyWith(color: Colours.green80Colour);
//   TextStyle get green60 => copyWith(color: Colours.green60Colour);
//   TextStyle get green40 => copyWith(color: Colours.green40Colour);
//   TextStyle get green20 => copyWith(color: Colours.green20Colour);

//   // Red Colors
//   TextStyle get red100 => copyWith(color: Colours.red100Colour);
//   TextStyle get red80 => copyWith(color: Colours.red80Colour);
//   TextStyle get red60 => copyWith(color: Colours.red60Colour);
//   TextStyle get red40 => copyWith(color: Colours.red40Colour);
//   TextStyle get red20 => copyWith(color: Colours.red20Colour);
// }
