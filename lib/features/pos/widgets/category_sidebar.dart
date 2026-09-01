import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/pos_provider.dart';
import '../../../core/models/menu_item.dart';

class CategorySidebar extends StatelessWidget {
  final bool isMobile;
  const CategorySidebar({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final sidebarWidth = isMobile ? 80.0 : 250.0;
    
    // Exact colors from the image
    final primaryOrange = const Color(0xFFFF6D00);
    final darkBrownIcon = const Color(0xFF5D4037);

    return Container(
      width: sidebarWidth,
      padding: EdgeInsets.only(
        left: isMobile ? 12 : 24,
        right: isMobile ? 12 : 24,
        top: 24,
        bottom: 24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── MAIN WHITE CONTAINER ──
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orange Header (All Items)
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: primaryOrange,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.grid_view_rounded,
                          color: Colors.white,
                          size: isMobile ? 16 : 18,
                        ),
                        if (!isMobile) ...[
                          const SizedBox(width: 8),
                          const Text(
                            'All Items',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Categories List
                  Expanded(
                    child: Consumer<POSProvider>(
                      builder: (context, provider, _) {
                        return ListView.separated(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: AppData.categories.length,
                          separatorBuilder: (context, index) => Divider(
                            color: Colors.grey.shade100,
                            height: 1,
                            thickness: 1,
                            indent: 16,
                            endIndent: 16,
                          ),
                          itemBuilder: (context, index) {
                            final category = AppData.categories[index];
                            final isSelected =
                                provider.selectedCategory == category.id;

                            return _CategoryItem(
                              category: category,
                              isSelected: isSelected,
                              isMobile: isMobile,
                              darkBrownIcon: darkBrownIcon,
                              primaryOrange: primaryOrange,
                              onTap: () => provider.selectCategory(category.id),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── CUSTOM ITEM BUTTON ──
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.04), // Faint orange background
              border: Border.all(color: primaryOrange.withOpacity(0.2), width: 1.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.soup_kitchen, // Chef hat/food icon
                      color: primaryOrange,
                      size: isMobile ? 20 : 22,
                    ),
                    if (!isMobile) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Custom Item',
                        style: TextStyle(
                          color: primaryOrange,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final MenuCategory category;
  final bool isSelected;
  final bool isMobile;
  final Color darkBrownIcon;
  final Color primaryOrange;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.isMobile,
    required this.darkBrownIcon,
    required this.primaryOrange,
    required this.onTap,
  });

  IconData _getIconForCategory(String name) {
    final lowerName = name.toLowerCase();
    if (lowerName.contains('popular')) return Icons.star_border;
    if (lowerName.contains('starter')) return Icons.soup_kitchen_outlined;
    if (lowerName.contains('main')) return Icons.set_meal_outlined;
    if (lowerName.contains('pizza')) return Icons.local_pizza_outlined;
    if (lowerName.contains('burger')) return Icons.lunch_dining_outlined;
    if (lowerName.contains('pasta')) return Icons.dinner_dining_outlined;
    if (lowerName.contains('rice')) return Icons.rice_bowl_outlined;
    if (lowerName.contains('drink')) return Icons.local_cafe_outlined;
    if (lowerName.contains('dessert')) return Icons.cake_outlined;
    if (lowerName.contains('side')) return Icons.fastfood_outlined;
    if (lowerName.contains('add')) return Icons.add_box_outlined;
    return Icons.restaurant_menu;
  }

  @override
  Widget build(BuildContext context) {
    final iconColor = isSelected ? primaryOrange : darkBrownIcon;
    final textColor = isSelected ? primaryOrange : Colors.black87;

    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 0 : 20,
          vertical: 12,
        ),
        color: isSelected ? primaryOrange.withOpacity(0.04) : Colors.transparent,
        child: Row(
          mainAxisAlignment: isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            Icon(
              _getIconForCategory(category.name),
              size: 20,
              color: iconColor,
            ),
            if (!isMobile) ...[
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  category.name,
                  style: TextStyle(
                    fontSize: 13,
                    color: textColor,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
