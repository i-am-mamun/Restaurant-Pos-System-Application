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
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: const OrderSummaryPanel(isBottomSheet: true),
        ),
      ),
    );
  }
}
