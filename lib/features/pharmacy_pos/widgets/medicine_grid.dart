import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/theme_extensions.dart';
import '../providers/pharmacy_provider.dart';
import '../models/medicine_model.dart';

class MedicineGrid extends StatelessWidget {
  const MedicineGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header & Filters
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'All Medicines',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(width: 16),
                _buildFilters(context),
              ],
            ),
            Icon(Icons.settings_outlined, color: context.textSecondary, size: 20),
          ],
        ),
        const SizedBox(height: 12),
        // Grid
        Expanded(
          child: Consumer<PharmacyProvider>(
            builder: (context, provider, _) {
              final items = provider.filteredMedicines;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  mainAxisExtent: 85, // Increased from 70 to prevent overflow
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _GridMedicineCard(medicine: items[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    final filters = [
      {'name': 'A-Z', 'color': const Color(0xFF009688), 'textColor': Colors.white},
      {'name': 'Popular', 'color': context.isDark ? context.cardBg : Colors.grey.withOpacity(0.1), 'textColor': context.textSecondary},
      {'name': 'Low Stock', 'icon': Icons.warning_amber_rounded, 'color': context.isDark ? context.cardBg : Colors.grey.withOpacity(0.1), 'textColor': Colors.orange},
      {'name': 'Expiring Soon', 'icon': Icons.calendar_today_rounded, 'color': context.isDark ? context.cardBg : Colors.grey.withOpacity(0.1), 'textColor': Colors.red},
    ];

    return Consumer<PharmacyProvider>(
      builder: (context, provider, _) {
        return Row(
          children: filters.map((f) {
            final isSelected = provider.selectedFilter == f['name'];
            final bgColor = isSelected ? const Color(0xFF009688) : f['color'] as Color;
            final textColor = isSelected ? Colors.white : f['textColor'] as Color;

            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: InkWell(
                onTap: () => provider.setFilter(f['name'] as String),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? const Color(0xFF009688) : (context.isDark ? context.dividerColor : Colors.transparent),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (f.containsKey('icon')) ...[
                        Icon(f['icon'] as IconData, size: 14, color: textColor),
                        const SizedBox(width: 4),
                      ],
                      Text(
                        f['name'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}

class _GridMedicineCard extends StatelessWidget {
  final MedicineModel medicine;

  const _GridMedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: context.isDark ? context.cardBg : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: context.isDark ? context.dividerColor : Colors.grey.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 50,
            height: 50,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Image.asset(
              medicine.imagePath,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.medication_rounded, color: Colors.blue.shade400, size: 24),
            ),
          ),
          const SizedBox(width: 10),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: context.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  medicine.genericName,
                  style: TextStyle(
                    fontSize: 11,
                    color: context.textSecondary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  '৳ ${medicine.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF009688),
                  ),
                ),
              ],
            ),
          ),
          // Add button
          InkWell(
            onTap: () {
              context.read<PharmacyProvider>().addToCart(medicine);
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFF009688),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}
