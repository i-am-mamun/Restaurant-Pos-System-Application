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
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxHeight < 200) {
            return SingleChildScrollView(
              child: Column(
                children: const [
                  POSHeader(),
                  POSInfoBar(),
                ],
              ),
            );
          }

          return Column(
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
          );
        },
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Left side (Categories + Grid) with its own Bottom Action Bar
        Expanded(
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                // Order Type Selector (Dine In | Take Away | Delivery)
                const Padding(
                  padding: EdgeInsets.fromLTRB(12, 6, 12, 4),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: OrderTypeSegmentedControl(isMobile: true),
                  ),
                ),

                // Mobile Search Bar (Only shown when Search Icon in header is clicked)
                if (provider.isMobileSearchOpen)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 4, 12, 4),
                    child: Material(
                      color: Colors.white,
                      elevation: 0,
                      borderRadius: BorderRadius.circular(14),
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 16,
                              spreadRadius: 0,
                              offset: const Offset(0, 4),
                            ),
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const SizedBox(width: 8),
                            // Orange circle with white search icon
                            Container(
                              width: 28,
                              height: 28,
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
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextField(
                                autofocus: true,
                                onChanged: provider.setSearchQuery,
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF1A1A2E),
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 0.1,
                                ),
                                decoration: InputDecoration(
                                  hintText: 'Find your favourite dish...',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  border: InputBorder.none,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () => provider.setMobileSearchOpen(false),
                              behavior: HitTestBehavior.opaque,
                              child: Icon(
                                Icons.close_rounded,
                                color: Colors.grey.shade500,
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
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
