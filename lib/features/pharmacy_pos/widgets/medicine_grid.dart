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
        // ── Top Navigation/Filter Bar ──
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _NavButton(label: 'All Medicines', icon: Icons.medication_rounded, isSelected: true),
              const SizedBox(width: 8),
              _NavButton(label: 'Popular'),
              const SizedBox(width: 8),
              _NavButton(label: 'Low Stock', icon: Icons.warning_amber_rounded, iconColor: Colors.orange),
              const SizedBox(width: 8),
              _NavButton(label: 'Expiring Soon', icon: Icons.calendar_today_rounded, iconColor: Colors.red),
              const SizedBox(width: 8),
              _NavButton(label: 'Prescription Required', icon: Icons.medical_services_rounded, iconColor: Colors.purple),
              const SizedBox(width: 8),
              _NavButton(label: 'Generic Available', icon: Icons.eco_rounded, iconColor: Colors.green),
              const SizedBox(width: 16),
              const Text('Sort by:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
              const SizedBox(width: 4),
              DropdownButton<String>(
                value: 'Name A-Z',
                underline: const SizedBox(),
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: context.textPrimary),
                items: ['Name A-Z', 'Price High-Low'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (_) {},
              ),
            ],
          ),
        ),
        
        const SizedBox(height: 16),
        
        // ── Medicine Grid ──
        Expanded(
          child: Consumer<PharmacyProvider>(
            builder: (context, provider, _) {
              final items = provider.filteredMedicines;
              return GridView.builder(
                padding: const EdgeInsets.only(bottom: 20),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 220,
                  mainAxisExtent: 210, // Increased from 170 to fully fix overflow
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _MedicineCard(medicine: items[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color? iconColor;
  final bool isSelected;

  const _NavButton({required this.label, this.icon, this.iconColor, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    const primaryTeal = Color(0xFF00695C);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? primaryTeal : (context.isDark ? context.inputBg : Colors.grey.shade100),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: isSelected ? primaryTeal : context.dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: isSelected ? Colors.white : (iconColor ?? Colors.grey)),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : context.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _MedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  const _MedicineCard({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.dividerColor, width: 1.2),
        boxShadow: [
          if (!context.isDark)
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image Area
          Expanded(
            flex: 5, // Adjusted flex for better image visibility
            child: Stack(
              children: [
                Center(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(10, 10, 10, 4),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        medicine.imagePath,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, progress) => progress == null 
                          ? child 
                          : const Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFF8FAFC),
                          child: const Center(child: Icon(Icons.medication_rounded, color: Color(0xFF009688), size: 36)),
                        ),
                      ),
                    ),
                  ),
                ),
                // Badges
                Positioned(
                  top: 12, left: 12, right: 12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (medicine.isRx) 
                        _BadgeIcon(icon: Icons.medical_services, color: Colors.purple),
                      const Spacer(),
                      if (medicine.alternatives != null)
                        _TextBadge(label: 'Alt: ${medicine.alternatives}', color: Colors.green),
                      if (medicine.isLowStock)
                        const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16),
                      if (medicine.isExpiringSoon)
                        _TextBadge(label: 'Exp: Soon', color: Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Details Area
          Expanded(
            flex: 4, // More space for text and price
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        medicine.name,
                        style: TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: context.textPrimary, height: 1.1),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        medicine.genericName,
                        style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
                        maxLines: 1, overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Stock: ${medicine.stock}',
                        style: TextStyle(fontSize: 10, color: context.textSecondary, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '৳ ${medicine.price.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Color(0xFF009688)),
                      ),
                      Material(
                        color: const Color(0xFF009688),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: () => context.read<PharmacyProvider>().addToCart(medicine),
                          customBorder: const CircleBorder(),
                          child: const Padding(
                            padding: EdgeInsets.all(5),
                            child: Icon(Icons.add, size: 18, color: Colors.white),
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
    );
  }
}

class _BadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _BadgeIcon({required this.icon, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Icon(icon, size: 10, color: color),
    );
  }
}

class _TextBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _TextBadge({required this.label, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
      child: Text(label, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: color)),
    );
  }
}



class _Badge extends StatelessWidget {
  final Color color;
  final IconData? icon;
  final Color? iconColor;
  final String? label;
  final Color? textColor;

  const _Badge({required this.color, this.icon, this.iconColor, this.label, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, size: 10, color: iconColor),
          if (label != null) Text(label!, style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}
