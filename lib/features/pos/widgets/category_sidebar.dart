import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/pos_provider.dart';
import '../../../core/models/menu_item.dart';
import 'dialogs/pos_dialogs.dart';


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
        top: 0,
        bottom: 6,
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
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Orange Header
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
                        return ListView.builder(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 6 : 10,
                            vertical: 8,
                          ),
                          itemCount: AppData.categories.length,
                          itemBuilder: (context, index) {
                            final category = AppData.categories[index];
                            final isSelected =
                                provider.selectedCategory == category.id;

                            return Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: _CategoryItem(
                                category: category,
                                isSelected: isSelected,
                                isMobile: isMobile,
                                darkBrownIcon: darkBrownIcon,
                                primaryOrange: primaryOrange,
                                onTap: () => provider.selectCategory(category.id),
                              ),
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

          const SizedBox(height: 10),

          // ── CUSTOM ITEM BUTTON ──
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: primaryOrange.withOpacity(0.04),
              border: Border.all(color: primaryOrange.withOpacity(0.2), width: 1.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (_) => const CustomItemDialog(),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.soup_kitchen,
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        color: isSelected ? primaryOrange.withOpacity(0.08) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? primaryOrange.withOpacity(0.4) : Colors.grey.shade200,
          width: 1.5,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: primaryOrange.withOpacity(0.12),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 8 : 16,
              vertical: 11,
            ),
            child: Row(
              mainAxisAlignment: isMobile
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Icon(
                  _getIconForCategory(category.name),
                  size: 20,
                  color: iconColor,
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: textColor,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (isSelected)
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: primaryOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileCategoryBar extends StatelessWidget {
  const MobileCategoryBar({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);
    final darkBrownText = const Color(0xFF5D4037);

    return Container(
      height: 70, // Slightly taller for premium feel and shadows
      color: Colors.white,
      child: Consumer<POSProvider>(
        builder: (context, provider, _) {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: AppData.categories.length,
            itemBuilder: (context, index) {
              final category = AppData.categories[index];
              final isSelected = provider.selectedCategory == category.id;

              return GestureDetector(
                onTap: () => provider.selectCategory(category.id),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutCubic,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? primaryOrange : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      if (isSelected)
                        BoxShadow(
                          color: primaryOrange.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        )
                      else
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      category.name == 'All' ? 'All Items' : category.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : darkBrownText,
                        fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        fontSize: 14,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
