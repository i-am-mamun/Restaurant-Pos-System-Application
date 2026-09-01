import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/providers/pos_provider.dart';
import '../widgets/pos_header.dart';
import '../widgets/pos_info_bar.dart';
import '../widgets/category_sidebar.dart';
import '../widgets/menu_grid.dart';
import '../widgets/order_summary_panel.dart';
import '../widgets/bottom_action_bar.dart';

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 768;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // Top Header Bar
          const POSHeader(),

          // Info Bar (Table, Guests, Waiter, Actions)
          const POSInfoBar(),

          // Main Content
          Expanded(
            child: isTablet
                ? _buildTabletLayout(context)
                : _buildMobileLayout(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      children: [
        // Left side (Categories + Grid) with its own Bottom Action Bar
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  children: [
                    const CategorySidebar(),
                    const Expanded(
                      child: MenuGrid(),
                    ),
                  ],
                ),
              ),
              const BottomActionBar(),
            ],
          ),
        ),

        // Right - Order Summary
        const OrderSummaryPanel(),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Consumer<POSProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            Column(
              children: [
                // Mobile Search Bar - Premium Design v2
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
                  child: Material(
                    color: Colors.white,
                    elevation: 0,
                    borderRadius: BorderRadius.circular(18),
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.07),
                            blurRadius: 24,
                            spreadRadius: 0,
                            offset: const Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 10),
                          // Orange circle with white search icon
                          Container(
                            width: 34,
                            height: 34,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFFFF6D00), Color(0xFFFF9E45)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.search_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              onChanged: provider.setSearchQuery,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF1A1A2E),
                                fontWeight: FontWeight.w500,
                                letterSpacing: 0.1,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Find your favourite dish...',
                                hintStyle: TextStyle(
                                  color: Colors.grey.shade400,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          // Subtle divider + mic icon
                          Container(
                            width: 1,
                            height: 22,
                            color: Colors.grey.shade200,
                            margin: const EdgeInsets.symmetric(horizontal: 8),
                          ),
                          Icon(
                            Icons.mic_none_rounded,
                            color: const Color(0xFFFF6D00),
                            size: 22,
                          ),
                          const SizedBox(width: 14),
                        ],
                      ),
                    ),
                  ),
                ),

                // Top - Categories (Horizontal scroll)
                const MobileCategoryBar(),

                // Menu Grid
                const Expanded(
                  child: MenuGrid(isMobile: true),
                ),
              ],
            ),

            // Cart FAB for mobile
            Positioned(
              bottom: 16,
              right: 16,
              child: FloatingActionButton.extended(
                onPressed: () => _showMobileOrderSummary(context),
                backgroundColor: AppColors.primary,
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  '${provider.totalItemCount} items • \$${provider.totalPayable.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMobileOrderSummary(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: true,          // Tap outside to close
      enableDrag: true,             // Drag down to close
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.5), // Dark overlay
      builder: (ctx) => GestureDetector(
        // Tap on transparent area ABOVE the sheet → close
        onTap: () => Navigator.of(ctx).pop(),
        behavior: HitTestBehavior.opaque,
        child: DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.3,
          snap: true,
          snapSizes: const [0.3, 0.85, 0.95],
          builder: (_, scrollController) => GestureDetector(
            // Prevent taps on the sheet itself from bubbling up to the barrier
            onTap: () {},
            behavior: HitTestBehavior.opaque,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  // Drag Handle
                  Padding(
                    padding: const EdgeInsets.only(top: 12, bottom: 4),
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const Expanded(
                    child: OrderSummaryPanel(isBottomSheet: true),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
