import 'package:flutter/material.dart';
import 'package:mall_blackstone/Utils/Constants/app_colors.dart';

class CustomGradientBackground extends StatelessWidget {
  const CustomGradientBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.Pink,
            AppColors.LightPink,
            AppColors.LightPink.withOpacity(0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
