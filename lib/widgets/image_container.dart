// image_container.dart
import 'package:flutter/material.dart';
import 'package:mall_blackstone/Utils/Constants/app-dimensions.dart';
import 'package:mall_blackstone/Utils/Constants/app_colors.dart';

class ImageContainer extends StatelessWidget {
  final String imagePath;
  final String text;
  final bool isSelected;

  const ImageContainer({
    Key? key,
    required this.imagePath,
    required this.text,
    this.isSelected = false,
    required void Function() onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      height: 70,
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        border: Border.all(
          color: isSelected ? AppColors.Pink : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(blurRadius: 3, color: AppColors.Black.withOpacity(0.2)),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            height: 33,
            width: 33,
            child: Image.asset(imagePath, fit: BoxFit.contain),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 4),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 8,
                fontWeight: FontWeight.w600,
                fontFamily: 'Madimi',
                color: AppColors.Black,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
