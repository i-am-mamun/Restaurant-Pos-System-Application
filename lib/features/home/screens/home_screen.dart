import 'package:flutter/material.dart';
import '../../restaurant_pos/screens/pos_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6D00).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.storefront_rounded,
                      color: Color(0xFFFF6D00),
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ZestBite Enterprise',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Select a point of sale system',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, color: Colors.grey),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Global Settings Coming Soon')),
                      );
                    },
                  ),
                ],
              ),
            ),
            
            // Grid Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: [
                        _ModuleCard(
                          title: 'Restaurant POS',
                          description: 'Dine-in, Takeaway, Tables, Kitchen',
                          icon: Icons.restaurant_rounded,
                          color: const Color(0xFFFF6D00),
                          isActive: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const POSScreen()),
                            );
                          },
                        ),
                        _ModuleCard(
                          title: 'Grocery POS',
                          description: 'Barcode scanning, Weight scaling, Inventory',
                          icon: Icons.local_grocery_store_rounded,
                          color: Colors.green.shade600,
                          isActive: false,
                          onTap: () => _showComingSoon(context, 'Grocery POS'),
                        ),
                        _ModuleCard(
                          title: 'Pharmacy POS',
                          description: 'Prescriptions, Expiry tracking, Batch mgmt',
                          icon: Icons.local_pharmacy_rounded,
                          color: Colors.blue.shade600,
                          isActive: false,
                          onTap: () => _showComingSoon(context, 'Pharmacy POS'),
                        ),
                        _ModuleCard(
                          title: 'Wholesaler POS',
                          description: 'Bulk orders, Customer credit, B2B pricing',
                          icon: Icons.inventory_2_rounded,
                          color: Colors.purple.shade600,
                          isActive: false,
                          onTap: () => _showComingSoon(context, 'Wholesaler POS'),
                        ),
                        _ModuleCard(
                          title: 'Fashion & Retail',
                          description: 'Variants, Sizes, Colors, Returns',
                          icon: Icons.checkroom_rounded,
                          color: Colors.pink.shade500,
                          isActive: false,
                          onTap: () => _showComingSoon(context, 'Fashion Retail POS'),
                        ),
                        _ModuleCard(
                          title: 'Dashboard & Reports',
                          description: 'Analytics, Multi-store management',
                          icon: Icons.analytics_rounded,
                          color: Colors.teal.shade600,
                          isActive: false,
                          onTap: () => _showComingSoon(context, 'Enterprise Dashboard'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context, String moduleName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🚀 $moduleName is coming soon!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.black87,
      ),
    );
  }
}

class _ModuleCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 300,
        height: 180,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? color.withOpacity(0.5) : Colors.grey.shade200,
            width: isActive ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: isActive ? color.withOpacity(0.15) : Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isActive ? color.withOpacity(0.1) : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    icon,
                    size: 32,
                    color: isActive ? color : Colors.grey.shade500,
                  ),
                ),
                if (!isActive)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SOON',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                  ),
              ],
            ),
            const Spacer(),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: isActive ? Colors.black87 : Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
