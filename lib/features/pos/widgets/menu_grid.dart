import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/providers/pos_provider.dart';
import '../../../core/models/menu_item.dart';

class MenuGrid extends StatelessWidget {
  final bool isMobile;
  const MenuGrid({super.key, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return Container(
        color: Colors.white,
        child: Column(
          children: [
            _MenuHeader(isMobile: isMobile),
            Expanded(
              child: Consumer<POSProvider>(
                builder: (context, provider, _) {
                  final items = provider.filteredMenuItems;
                  if (items.isEmpty) {
                    return const Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(color: Colors.grey),
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
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: _PaginationDots(),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(
        left: 0,
        right: 16,
        top: 0,
        bottom: 6,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
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
                        child: Text(
                          'No items found',
                          style: TextStyle(color: Colors.grey),
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

              // Pagination Dots (Static for UI matching)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: _PaginationDots(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────────
class _MenuHeader extends StatelessWidget {
  final bool isMobile;
  const _MenuHeader({this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    if (isMobile) {
      return const SizedBox.shrink(); // Hide redundant header on mobile
    }

    final primaryOrange = const Color(0xFFFF6D00);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final categoryName = AppData.categories
            .firstWhere((c) => c.id == provider.selectedCategory)
            .name;

        return Container(
          padding: EdgeInsets.only(
            left: isMobile ? 12 : 24,
            right: isMobile ? 12 : 24,
            top: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade100, width: 2),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Category Title with Bottom Border
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: primaryOrange, width: 3),
                  ),
                ),
                child: Text(
                  categoryName == 'All' ? 'All Items' : categoryName,
                  style: TextStyle(
                    fontSize: isMobile ? 16 : 18,
                    fontWeight: FontWeight.w700,
                    color: primaryOrange,
                  ),
                ),
              ),

              const Spacer(),

              // View Toggle Button Group (Hide on mobile)
              if (!isMobile)
                Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ViewToggleBtn(
                        icon: Icons.grid_view_rounded,
                        label: 'Grid',
                        isSelected: provider.viewMode == 'grid',
                        onTap: () => provider.setViewMode('grid'),
                      ),
                      _ViewToggleBtn(
                        icon: Icons.format_list_bulleted_rounded,
                        label: 'List',
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
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ViewToggleBtn({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryOrange : Colors.transparent,
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.grey.shade700,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// GRID VIEW
// ─────────────────────────────────────────────────────────────────
class _MenuGridView extends StatelessWidget {
  final List<MenuItem> items;
  final bool isMobile;

  const _MenuGridView({required this.items, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4; // Matches the image
    } else if (screenWidth >= 900) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 2;
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 24,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: isMobile ? 12 : 20,
        mainAxisSpacing: isMobile ? 12 : 20,
        childAspectRatio: isMobile ? 0.8 : 0.82,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) => _MenuItemCard(
        item: items[index],
        isMobile: isMobile,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// ITEM CARD
// ─────────────────────────────────────────────────────────────────
class _MenuItemCard extends StatelessWidget {
  final MenuItem item;
  final bool isMobile;

  const _MenuItemCard({required this.item, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);

    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        final inCart = provider.isInCart(item.id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade100, width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section (Full width, no padding, clipped to top corners)
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Container(
                        width: double.infinity,
                        color: Colors.grey.shade50, // very light background for image
                        child: CachedNetworkImage(
                          imageUrl: item.imageUrl,
                          fit: BoxFit.cover, // Ensures it fills the space
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFFFF6D00),
                            ),
                          ),
                          errorWidget: (context, url, error) => Center(
                            child: Icon(
                              Icons.fastfood,
                              color: Colors.grey.shade300,
                              size: 40,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Info Section (Name, Price, Add Button)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isMobile ? 12 : 16,
                      vertical: isMobile ? 10 : 12,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: isMobile ? 14 : 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8), // Perfect small gap
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: isMobile ? 14 : 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            // Quantity Controller (shows - qty + when in cart)
                            inCart
                                ? Container(
                                    height: isMobile ? 30 : 34,
                                    decoration: BoxDecoration(
                                      color: primaryOrange.withOpacity(0.08),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        // Minus button
                                        GestureDetector(
                                          onTap: () => provider.decrementQuantity(item.id),
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            width: isMobile ? 26 : 30,
                                            height: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: primaryOrange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.remove,
                                              color: Colors.white,
                                              size: isMobile ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                        // Quantity number
                                        Container(
                                          width: isMobile ? 26 : 30,
                                          alignment: Alignment.center,
                                          child: Text(
                                            '${provider.getQuantity(item.id)}',
                                            style: TextStyle(
                                              fontSize: isMobile ? 13 : 14,
                                              fontWeight: FontWeight.w800,
                                              color: primaryOrange,
                                            ),
                                          ),
                                        ),
                                        // Plus button
                                        GestureDetector(
                                          onTap: () => provider.addToCart(item),
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            width: isMobile ? 26 : 30,
                                            height: double.infinity,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                              color: primaryOrange,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: isMobile ? 14 : 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () => provider.addToCart(item),
                                    behavior: HitTestBehavior.opaque,
                                    child: Container(
                                      width: isMobile ? 30 : 34,
                                      height: isMobile ? 30 : 34,
                                      decoration: BoxDecoration(
                                        color: primaryOrange,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        Icons.add,
                                        color: Colors.white,
                                        size: isMobile ? 18 : 22,
                                      ),
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Badges Section (Top Left and Top Right)
              Positioned(
                top: 10,
                left: 10,
                right: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Left (Popular / Star)
                    if (item.isPopular)
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2), // White border
                        ),
                        child: const Icon(
                          Icons.star,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    else
                      const SizedBox.shrink(),

                    // Top Right (Veg / Leaf)
                    if (item.isVeg)
                      Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2), // White border
                        ),
                        child: const Icon(
                          Icons.eco,
                          color: Colors.white,
                          size: 14,
                        ),
                      )
                    else
                      const SizedBox.shrink(),
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

// ─────────────────────────────────────────────────────────────────
// LIST VIEW (Simplified for when user toggles to list)
// ─────────────────────────────────────────────────────────────────
class _MenuListView extends StatelessWidget {
  final List<MenuItem> items;
  final bool isMobile;

  const _MenuListView({required this.items, this.isMobile = false});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 12 : 24,
        vertical: 16,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Consumer<POSProvider>(
          builder: (context, provider, _) {
            final inCart = provider.isInCart(item.id);
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade100, width: 1.5),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${item.price.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Quantity Controller (same as grid card)
                  inCart
                      ? Container(
                          height: 36,
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF6D00).withOpacity(0.08),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Minus button
                              GestureDetector(
                                onTap: () => provider.decrementQuantity(item.id),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 36,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6D00),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.remove,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                              // Quantity number
                              Container(
                                width: 36,
                                alignment: Alignment.center,
                                child: Text(
                                  '${provider.getQuantity(item.id)}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFFFF6D00),
                                  ),
                                ),
                              ),
                              // Plus button
                              GestureDetector(
                                onTap: () => provider.addToCart(item),
                                behavior: HitTestBehavior.opaque,
                                child: Container(
                                  width: 36,
                                  height: double.infinity,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFF6D00),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : GestureDetector(
                          onTap: () => provider.addToCart(item),
                          behavior: HitTestBehavior.opaque,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6D00),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────
// PAGINATION DOTS (UI only, to match image)
// ─────────────────────────────────────────────────────────────────
class _PaginationDots extends StatelessWidget {
  const _PaginationDots();

  @override
  Widget build(BuildContext context) {
    final primaryOrange = const Color(0xFFFF6D00);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildDot(primaryOrange),
        const SizedBox(width: 8),
        _buildDot(Colors.grey.shade400),
        const SizedBox(width: 8),
        _buildDot(Colors.grey.shade400),
      ],
    );
  }

  Widget _buildDot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
