import 'package:flutter/material.dart';
import 'package:mall_blackstone/Utils/Constants/app-dimensions.dart';
import 'package:mall_blackstone/Utils/Constants/app_colors.dart';
import 'package:mall_blackstone/Utils/Constants/app_styles.dart';

class RechargeBalanceCard extends StatefulWidget {
  const RechargeBalanceCard({super.key});

  @override
  State<RechargeBalanceCard> createState() => _RechargeBalanceCardState();
}

class _RechargeBalanceCardState extends State<RechargeBalanceCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.White,
        borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(blurRadius: 3, color: AppColors.Black.withOpacity(0.2)),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
          vertical: AppDimensions.paddingSmall,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 25, backgroundImage: NetworkImage('')),
                    SizedBox(width: AppDimensions.paddingSmall),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Balance', style: AppStyles.subtitleText),
                        SizedBox(height: AppDimensions.paddingXSmall),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              'assets/icons/gold_diamond.png',
                              height: AppDimensions.iconSizeSmall,
                              width: AppDimensions.iconSizeSmall,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: AppDimensions.paddingSmall),
                            Text(
                              '0',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                fontFamily: 'Madimi',
                                color: Colors.orange.shade700,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(width: 5),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/icons/recharge.png',
                      height: AppDimensions.iconSizeLarge,
                      width: AppDimensions.iconSizeXLarge * 2.5,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 5,
                      child: Text(
                        'Recharge',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Madimi',
                          color: Colors.orange.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
