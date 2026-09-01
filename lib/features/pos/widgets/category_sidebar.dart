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
    final sidebarWidth = isMobile ? 64.0 : 140.0;

    return Container(
      width: sidebarWidth,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: AppColors.borderLight),
        ),
      ),
      child: Column(
        children: [
          Expanded(
            child: Consumer<POSProvider>(
              builder: (context, provider, _) {
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: isMobile ? 4 : 8,
                  ),
                  itemCount: AppData.categories.length,
                  itemBuilder: (context, index) {
                    final category = AppData.categories[index];
                    final isSelected = provider.selectedCategory == category.id;

                    return _CategoryItem(
                      category: category,
                      isSelected: isSelected,
                      isMobile: isMobile,
                      onTap: () => provider.selectCategory(category.id),
                    );
                  },
                );
              },
            ),
          ),

          // Custom Item Button
          if (!isMobile)
            Container(
              margin: const EdgeInsets.all(8),
              child: OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_circle_outline, size: 14),
                label: const Text(
                  'Custom Item',
                  style: TextStyle(fontSize: 11),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  minimumSize: const Size(double.infinity, 36),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          if (isMobile)
            Container(
              margin: const EdgeInsets.all(6),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primary),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.add,
                    color: AppColors.primary,
                    size: 16,
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
  final VoidCallback onTap;

  const _CategoryItem({
    required this.category,
    required this.isSelected,
    required this.isMobile,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(vertical: 2),
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.3))
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                category.icon,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 2),
              Text(
                category.name.split(' ')[0],
                style: TextStyle(
                  fontSize: 8,
                  color:
                      isSelected ? AppColors.primary : AppColors.textSecondary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withOpacity(0.2)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  category.icon,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                  fontWeight:
                      isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
