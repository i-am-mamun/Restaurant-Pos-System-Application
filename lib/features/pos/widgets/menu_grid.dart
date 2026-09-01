import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/pos_provider.dart';
import '../../../core/models/menu_item.dart';

class MenuGrid extends StatelessWidget {
  final bool isMobile;
  const MenuGrid({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      child: Column(
        children: [
          // Menu Header with category title + view toggle
          _MenuHeader(isMobile: isMobile),

          // Grid Content
          Expanded(
            child: Consumer<POSProvider>(
              builder: (context, provider, _) {
                final items = provider.filteredMenuItems;
                if (items.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off, size: 48, color: AppColors.textLight),
                        SizedBox(height: 8),
                        Text(
                          'No items found',
                          style: TextStyle(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  );
                }

                if (provider.viewMode == 'list') {
                  return _MenuListView(items: items, isMobile: isMobile);
                }

                return _MenuGridView(items: items, isMobile: isMobile);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuHeader extends StatelessWidget {
  final bool isMobile;
  const _MenuHeader({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final categoryName = AppData.categories
            .firstWhere((c) => c.id == provider.selectedCategory)
            .name;

        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 16,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: AppColors.borderLight),
            ),
          ),
          child: Row(
            children: [
              Text(
                categoryName,
                style: TextStyle(
                  fontSize: isMobile ? 13 : 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              // View Toggle
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.borderLight),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    _ViewToggleBtn(
                      icon: Icons.grid_view,
                      mode: 'grid',
                      isSelected: provider.viewMode == 'grid',
                      onTap: () => provider.setViewMode('grid'),
                    ),
                    _ViewToggleBtn(
                      icon: Icons.list,
                      mode: 'list',
                      isSelected: provider.viewMode == 'list',
                      onTap: () => provider.setViewMode('list'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ViewToggleBtn extends StatelessWidget {
  final IconData icon;
  final String mode;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleBtn({
    required this.icon,
    required this.mode,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          borderRadius: mode == 'grid'
              ? const BorderRadius.horizontal(left: Radius.circular(7))
              : const BorderRadius.horizontal(right: Radius.circular(7)),
        ),
        child: Icon(
          icon,
          size: 16,
          color: isSelected ? Colors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _MenuGridView extends StatelessWidget {
  final List<MenuItem> items;
  final bool isMobile;

  const _MenuGridView({required this.items, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 900) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }

    return GridView.builder(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isMobile ? 8 : 10,
        mainAxisSpacing: isMobile ? 8 : 10,
        childAspectRatio: isMobile ? 0.78 : 0.80,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _MenuItemCard(
        item: items[index],
        isMobile: isMobile,
      ),
    );
  }
}

class _MenuListView extends StatelessWidget {
  final List<MenuItem> items;
  final bool isMobile;

  const _MenuListView({required this.items, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(isMobile ? 8 : 12),
      itemCount: items.length,
      itemBuilder: (context, index) => _MenuListItemCard(
        item: items[index],
        isMobile: isMobile,
      ),
    );
  }
}

class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isMobile;

  const _MenuItemCard({required this.item, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(item.id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Expanded(
                    flex: 6,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: item.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (context, url) => Container(
                          color: AppColors.background,
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          color: AppColors.background,
                          child: const Icon(
                            Icons.fastfood,
                            color: AppColors.textLight,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Info
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.all(isMobile ? 6 : 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: isMobile ? 11 : 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: isMobile ? 12 : 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => provider.addToCart(item),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  width: isMobile ? 26 : 28,
                                  height: isMobile ? 26 : 28,
                                  decoration: BoxDecoration(
                                    color: inCart
                                        ? AppColors.success
                                        : AppColors.primary,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Icon(
                                    inCart ? Icons.check : Icons.add,
                                    color: Colors.white,
                                    size: isMobile ? 14 : 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              // Badges
              Positioned(
                top: 6,
                left: 6,
                child: Column(
                  children: [
                    if (item.isPopular)
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    if (item.isVeg) ...[
                      const SizedBox(height: 4),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.vegBadge,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MenuListItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isMobile;

  const _MenuListItemCard({required this.item, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(item.id);

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  imageUrl: item.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: AppColors.background,
                    width: 60,
                    height: 60,
                  ),
                  errorWidget: (context, url, error) => Container(
                    color: AppColors.background,
                    width: 60,
                    height: 60,
                    child: const Icon(Icons.fastfood, color: AppColors.textLight),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        if (item.isPopular)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Popular',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        if (item.isVeg)
                          Container(
                            margin: const EdgeInsets.only(right: 4),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: AppColors.vegBadge.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Veg',
                              style: TextStyle(
                                  fontSize: 9,
                                  color: AppColors.vegBadge,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '\$${item.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => provider.addToCart(item),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: inCart ? AppColors.success : AppColors.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    inCart ? Icons.check : Icons.add,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
