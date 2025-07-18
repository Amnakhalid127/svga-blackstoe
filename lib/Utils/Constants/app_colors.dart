import 'package:flutter/widgets.dart';

class AppColors {
  static Color Red = const Color(0xffF22C33);
  static Color Pink = const Color(0xffFE85D5);
  static Color LightPink = const Color(0xffFFD5EB);
  static Color ExtralightPink = const Color(0xffFFD5EB);
  static Color DarkPink = const Color(0xffFFD5EB);
  static Color Orange = const Color(0xffFFD5EB);
  static Color Black = const Color(0xff000000);
  static Color White = const Color(0xffffffff);
  static Color disalecolors = const Color(0xffFFD5EB);
  static Color yellow = const Color(0xffFFC851);
  static Color LightYellow = const Color(0xffF6D66C);

  static var primaryGradient;
}

class Gradients {
  static Gradient primaryGradient = LinearGradient(
    colors: [AppColors.Pink, AppColors.Red],
  );
  static Gradient secondayGradient = LinearGradient(
    colors: [AppColors.DarkPink, AppColors.Orange],
  );
  static Gradient pinkGradient = const LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFFF4081)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
