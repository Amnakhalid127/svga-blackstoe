import 'package:flutter/material.dart';
import 'package:mall_blackstone/Utils/Constants/app-dimensions.dart';
import 'package:mall_blackstone/provider/shop_provider.dart';
import 'package:mall_blackstone/services/animationservices.dart';
import 'package:provider/provider.dart';
import '../utils/constants/app_colors.dart';
import '../utils/constants/app_styles.dart';
import '../widgets/custom_gradient_background.dart';
import '../widgets/recharge_balance_card.dart';
import '../widgets/image_container.dart';
import 'package:flutter/services.dart';

class MallScreen extends StatefulWidget {
  const MallScreen({super.key});

  @override
  State<MallScreen> createState() => _MallScreenState();
}

class _MallScreenState extends State<MallScreen> {
  final AnimationService _animationService = AnimationService();
  int _selectedContainerIndex = 0;

  // Static data for the 5 containers
  final List<Map<String, String>> staticContainers = [
    {'image': 'assets/icons/Rank-1.png', 'name': 'Headware'},
    {'image': 'assets/icons/Rank-2.png', 'name': 'Props'},
    {'image': 'assets/icons/Rank-3.png', 'name': 'Vehicle'},
    {'image': 'assets/icons/Rank-1.png', 'name': 'Bubble'},
    {'image': 'assets/icons/Rank-2.png', 'name': 'Roomware'},
  ];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).fetchItems();
    });
  }

  void _showFullScreenAnimation(String imageUrl, Duration? duration) {
    HapticFeedback.lightImpact();

    _animationService.playAnimation(
      context,
      imageUrl,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  Widget _buildErrorState(String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.Pink),
          const SizedBox(height: 16),
          Text(
            'Error: $errorMessage',
            style: AppStyles.bodyText,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () =>
                Provider.of<ShopProvider>(context, listen: false).fetchItems(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.Pink,
              foregroundColor: AppColors.White,
            ),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticContainer(Map<String, String> containerData, int index) {
    return GestureDetector(
      onTap: () {
        setState(() => _selectedContainerIndex = index);
        // For static containers, show for default duration
        _showFullScreenAnimation(containerData['image']!, null);
      },
      child: Container(
        width:
            (MediaQuery.of(context).size.width -
                (AppDimensions.screenPadding * 2) -
                (AppDimensions.paddingSmall * 4)) /
            5,
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          border: Border.all(
            color: index == _selectedContainerIndex
                ? AppColors.Pink
                : Colors.grey.shade300,
            width: index == _selectedContainerIndex ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: index == _selectedContainerIndex ? 8 : 4,
              color:
                  (index == _selectedContainerIndex
                          ? AppColors.Pink
                          : Colors.grey)
                      .withOpacity(0.2),
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 42,
                height: 42,
                child: Image.asset(
                  containerData['image']!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.image_not_supported,
                      color: Colors.grey[600],
                      size: 20,
                    );
                  },
                ),
              ),
              SizedBox(height: AppDimensions.paddingXSmall),
              Text(
                containerData['name']!,
                style: AppStyles.bodyText.copyWith(
                  fontSize: 11,
                  fontWeight: index == _selectedContainerIndex
                      ? FontWeight.w600
                      : FontWeight.w500,
                  color: index == _selectedContainerIndex
                      ? AppColors.Pink
                      : AppColors.Black,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(List<Map<String, dynamic>> items) {
    return Column(
      children: [
        RechargeBalanceCard(),
        SizedBox(height: AppDimensions.paddingMedium),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: staticContainers.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> containerData = entry.value;
            return _buildStaticContainer(containerData, index);
          }).toList(),
        ),

        SizedBox(height: AppDimensions.paddingMedium),

        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_bag_outlined,
                        size: 64,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No items available',
                        style: AppStyles.bodyText.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  mainAxisSpacing: AppDimensions.paddingMedium,
                  crossAxisSpacing: AppDimensions.paddingMedium,
                  childAspectRatio: 0.85,
                  children: List.generate(
                    items.length,
                    (index) => _buildGridItem(items[index]),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildGridItem(Map<String, dynamic> item) {
    return GestureDetector(
      onTap: () {
        // Get animation duration from API if available
        Duration? animationDuration;
        if (item.containsKey('animationDuration')) {
          // Assuming API returns duration in seconds
          int durationInSeconds = item['animationDuration'] ?? 4;
          animationDuration = Duration(seconds: durationInSeconds);
        }

        _showFullScreenAnimation(item['itemPic'], animationDuration);
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.White,
          borderRadius: BorderRadius.circular(AppDimensions.borderRadiusMedium),
          border: Border.all(color: AppColors.Pink, width: 1.5),
          boxShadow: [
            BoxShadow(
              blurRadius: 8,
              color: AppColors.Pink.withOpacity(0.2),
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.paddingSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image container
              Hero(
                tag: 'item_${item['itemName']}_${item['itemPic']}',
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      item['itemPic'],
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey[600],
                            size: 32,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                : null,
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.Pink,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // Item name
              Text(
                item['itemName'],
                style: AppStyles.subtitleText,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Duration row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_clock, color: AppColors.Pink, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '7 days',
                    style: AppStyles.bodyText.copyWith(
                      color: AppColors.Pink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Price row
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/gold_diamond.png',
                    height: AppDimensions.iconSizeSmall,
                    width: AppDimensions.iconSizeSmall,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    item['itemPrices']['7day'].toString(),
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Madimi',
                      color: Colors.orange.shade700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: AppColors.White,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_rounded, color: AppColors.Black),
        ),
        title: Text('Mall', style: AppStyles.AppBarBlackText),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          AspectRatio(aspectRatio: 6 / 4, child: CustomGradientBackground()),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(AppDimensions.screenPadding),
              child: shopProvider.errorMessage.isNotEmpty
                  ? Column(
                      children: [
                        RechargeBalanceCard(),
                        SizedBox(height: AppDimensions.paddingMedium),

                        // Static containers still show even on error
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: staticContainers.asMap().entries.map((
                            entry,
                          ) {
                            int index = entry.key;
                            Map<String, String> containerData = entry.value;
                            return _buildStaticContainer(containerData, index);
                          }).toList(),
                        ),

                        SizedBox(height: AppDimensions.paddingMedium),

                        // Error state for grid items
                        Expanded(
                          child: _buildErrorState(shopProvider.errorMessage),
                        ),
                      ],
                    )
                  : _buildContent(shopProvider.items),
            ),
          ),
        ],
      ),
    );
  }
}
